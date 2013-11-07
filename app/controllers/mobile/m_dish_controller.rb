# -*- encoding : utf-8 -*-
class Mobile::MDishController < Mobile::MoblieController

  def index
    type_id = params[:dish_type] ? params[:dish_type] : -1
    style_id = params[:dish_style] ? params[:dish_style] : -1
    if type_id.to_i == -1 && style_id.to_i == -1
      @list = Dish.order('id desc')
      render :json => @list.to_json(:except => [:created_at, :updated_at]) and return
    elsif type_id.to_i == -1
      @list = Dish.where('dish_style_id=?', style_id.to_i).order('id desc')
      render :json => @list.to_json(:except => [:created_at, :updated_at]) and return
    elsif style_id.to_i == -1
      @list = Dish.where('dish_type_id=?', type_id.to_i).order('id desc')
      render :json => @list.to_json(:except => [:created_at, :updated_at]) and return
    else
      @list = Dish.where(:dish_type_id => type_id.to_i, :dish_style_id => style_id.to_i).order('id desc')
      render :json => @list.to_json(:except => [:created_at, :updated_at]) and return
    end

  end

  def dish_type_list
    @list = DishType.order('id desc')
    render :json => @list.to_json(:include => {:dishes => {:except => [:created_at, :updated_at]}}, :except => [:created_at, :updated_at])
  end

  def dish_type_list_on_sale
    drop_list={:drop => [:created_at, :updated_at]}
    @list = DishType.order('id desc')
    result=[]
    if !@list.blank?
      @list.each do |dish_type|
        if !dish_type.blank?
          dish_type_hash=dish_type.to_hash(drop_list)
          dishes=dish_type.dishes.where('sales < 1.0').order('sales asc')
          dish_hash=[]
          if !dishes.blank?
            dishes.each do |dish|
              dish_hash<<dish.to_hash(drop_list)
            end
          end
          dish_type_hash[:dishes]=dish_hash
          result<<dish_type_hash
        end
      end
    end
    render :json => result
  end

  def dish_type_list_recommend
    drop_list={:drop => [:created_at, :updated_at]}
    @list = DishType.order('id desc')
    result=[]
    if !@list.blank?
      @list.each do |dish_type|
        if !dish_type.blank?
          dish_type_hash=dish_type.to_hash(drop_list)
          dishes=dish_type.dishes.where('count > 1').order('count desc')
          dish_hash=[]
          if !dishes.blank?
            dishes.each do |dish|
              dish_hash<<dish.to_hash(drop_list)
            end
          end
          dish_type_hash[:dishes]=dish_hash
          result<<dish_type_hash
        end
      end
    end
    render :json => result
  end

  def dish_style_list
    @list = DishStyle.order('id desc')
    render :json => @list.to_json(:include => {:dishes => {:except => [:created_at, :updated_at]}}, :except => [:created_at, :updated_at])
  end

end
