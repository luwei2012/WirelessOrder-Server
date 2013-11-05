# -*- encoding : utf-8 -*-
class Mobile::MTableController < Mobile::MoblieController


  def index
    @list = Table.order('id desc')
    render :json => @list.to_json(:except => [:created_at, :updated_at])
  end

  #查看当前已点菜品信息的接口
  #menu_id  :菜单的id
  #table_id  :桌子的id
  #result: 1成功  data:{menu.dishes}
  #        0失败，message: "菜单不存在"
  def dish_list
    begin
      table= Table.find(params[:table_id] ? params[:table_id].to_i : -1)
      if table.blank?
        #actually something is wrong, we should check the tables or we are under attack
        render :json => {:result => 0, :message => '菜单不存在，请联系服务员确认！'} and return
      else
        @menu=Menu.find(params[:menu_id])
        if @menu.blank? || @menu.table.id!=table.id
          render :json => {:result => 0, :message => '菜单不存在，请联系服务员确认！'} and return
        else
          #这里在客户端可以直接反序列化为Menu对象
          render :json => {:result => 1, :menu => @menu.to_json(:except => [:created_at, :updated_at], :include => {:dish_menus => {:include => {:dish => {:except => [:created_at, :updated_at]}}, :except => [:created_at, :updated_at]}})}
        end
      end
    rescue
      render :json => {:result => 0, :message => '桌号不存在，请联系服务员确认！'} and return
    end
  end

  #t.integer  "table_id"
  #t.float    "sales"
  #t.integer  "status"
  #t.datetime "created_at"
  #t.datetime "updated_at"

  #开桌接口
  #parames:
  # table_id :int   桌号
  #返回 result: 0  失败      message：失败原因
  #            1  成功      menu:int  menu的id，结账的时候需要使用
  def order
    begin
      table = Table.find(params[:table_id])
      if  table.status != 0
        render :json => {:result => 0, :message => '此桌已被占用！'} and return
      else
        begin
          @menu = table.menus.new
          Table.transaction do
            table.status=1
            @menu.sales=1.0
            @menu.status=0
            @menu.save!
            table.save!
          end
          render :json => {:result => 1, :menu => @menu.to_json(:except => [:created_at, :updated_at])} and return
        rescue
          render :json => {:result => 0, :message => '创建菜单失败，请呼叫服务员点餐！'} and return
        end
      end
    rescue
      render :json => {:result => 0, :message => '桌号不存在，请先联系服务员核实！'} and return
    end
  end

  #结账接口
  #menu_id :int   菜单的id
  # result: 0 失败 message:失败原因
  #         1 成功 price：int 总价格
  def check_out
    begin
      menu=Menu.find(params[:menu_id])
      if  menu.dish_menus.blank?
        #something is wrong ,please call the waiter
        render :json => {:result => 0, :message => '您尚未点菜，请先提交菜单，谢谢！'} and return
      elsif menu.status==1
        render :json => {:result => 0, :message => '正在结账，请耐心等待！'} and return
      else
        begin
          table = menu.table
          table.status=0
          menu.price=0
          menu.dish_menus.each do |dish_menu|
            dish = dish_menu.dish
            menu.price+=dish_menu.amount*dish.sales*dish.price
          end
          Menu.transaction do
            menu.price=menu.price*menu.sales
            menu.status=1
            menu.save!
            table.save!
          end
          render :json => {:result => 1, :price => menu.price} and return
        rescue
          render :json => {:result => 0, :message => '请呼叫服务员结账，谢谢！'} and return
        end
      end
    rescue
      render :json => {:result => 0, :message => '请呼叫服务员结账，谢谢！'} and return
    end


  end

  #添加菜品接口
  #menu_id :int  菜单的id
  #dish_id :   菜品的id
  #amount：int 该菜品的数量，默认为1
  #result: 0 失败，message：失败原因
  #        1 成功, .......
  def add_dish
    begin
      menu=Menu.find(params[:menu_id].to_i)
      dish=Dish.find(params[:dish_id].to_i)
      count=params[:amount] ? params[:amount].to_i : 1
      remarks=params[:remarks] ? params[:remarks].to_s : ''
      if dish.status==1
        begin
          dish_menu=DishMenu.find_by_menu_id_and_dish_id(menu.id, dish.id)
          if dish_menu.blank?
            dish_menu=menu.dish_menus.new(dish_id: dish.id)
            DishMenu.transaction do
              dish_menu.amount=count
              dish_menu.remarks = remarks
              dish_menu.save!
            end
          else
            DishMenu.transaction do
              dish_menu.amount+=count
              dish_menu.remarks =dish_menu.remarks ? dish_menu.remarks+ '\n'+remarks : remarks
              dish_menu.save!
            end
          end
          render :json => {:result => 1, :message => '添加成功！', :dish_menu => dish_menu.to_json(:except => [:created_at, :updated_at], :include => {:dish => {:except => [:created_at, :updated_at]}})} and return
        rescue
          render :json => {:result => 0, :message => '添加失败，请重试！'} and return
        end
      else
        render :json => {:result => 0, :message => '此菜品已卖完，请选择其他菜品！'} and return
      end
    rescue
      render :json => {:result => 0, :message => '添加失败，您可以呼叫服务员点菜！'} and return
    end

  end

  #删除菜品接口
  #menu_id int 菜单的id
  #dish_id : 菜品的id
  #amount：int 菜品的数量，默认为1
  def remove_dish
    begin
      menu=Menu.find(params[:menu_id].to_i)
      dish=Dish.find(params[:dish_id].to_i)
      count=params[:amount] ? params[:amount].to_i : 1
      if menu.status==0
        begin
          dish_menu=DishMenu.find_by_menu_id_and_dish_id(menu.id, dish.id)
          DishMenu.transaction do
            dish_menu.amount-=count
            if dish_menu.amount==0
              dish_menu.destroy!
            else
              dish_menu.save!
            end
            render :json => {:result => 1, :dish_menu => dish_menu.to_json(:except => [:created_at, :updated_at])} and return
          end
        rescue
          render :json => {:result => 0, :message => '删除失败，请重试！'} and return
        end
      elsif menu.status==1
        render :json => {:result => 0, :message => '您已经结账，无法删除已点菜品！'} and return
      else
        render :json => {:result => 0, :message => '菜单已经确认，需要删减请联系服务员！'} and return
      end

    rescue
      render :json => {:result => 0, :message => '您可以呼叫服务员删除此菜，谢谢！'} and return
    end

  end

  #确认下单，使餐单生效
  #menu_id 菜单的id
  def verify_menu
    begin
      menu = Menu.find(params[:menu_id].to_i)
      if menu.status != 1
        Menu.transaction do
          menu.status=2
          menu.save!
        end
        render :json => {:result => 1, :message => '菜单已经生效，请耐心等待！'} and return
      else
        render :json => {:result => 0, :message => '您已经结账，菜单已经过期！'} and return
      end
    rescue
      render :json => {:result => 0, :message => '菜单不存在或已经过期，请联系服务员！'} and return
    end
  end

end