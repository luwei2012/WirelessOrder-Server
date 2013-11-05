# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Mobile::MTableController do
  before(:each) do
    @dish_style_1=DishStyle.create! :name => '川菜', :describe => '色香味俱全'
    @dish_style_2=DishStyle.create! :name => '湘菜', :describe => '色香味俱全'
    @dish_style_3=DishStyle.create! :name => '浙菜', :describe => '色香味俱全'
    @dish_type_1=DishType.create! :name => '热菜', :describe => '一口暖人心'
    @dish_type_2=DishType.create! :name => '凉菜', :describe => '一口暖人心'
    @dish_type_3=DishType.create! :name => '汤', :describe => '一口暖人心'

    @dish_1 = Dish.create! :dish_style_id => @dish_style_1.id, :name => '榨菜汤', :price => 20, :remarks => '微辣', :status => 1, :count => 0, :sales => 1.0, :cost_time => 20, :dish_type_id => @dish_type_3.id
    @dish_2 = Dish.create! :dish_style_id => @dish_style_2.id, :name => '折耳根', :price => 20, :remarks => '腥，爽口', :status => 1, :count => 0, :sales => 1.0, :cost_time => 20, :dish_type_id => @dish_type_2.id
    @dish_3 = Dish.create! :dish_style_id => @dish_style_3.id, :name => '东坡肉', :price => 20, :remarks => '甜味', :status => 1, :count => 0, :sales => 1.0, :cost_time => 20, :dish_type_id => @dish_type_1.id
    @dish_4 = Dish.create! :dish_style_id => @dish_style_3.id, :name => '东坡肉', :price => 20, :remarks => '甜味', :status => 0, :count => 0, :sales => 1.0, :cost_time => 20, :dish_type_id => @dish_type_1.id

    @table_1=Table.create! :name => '大桌', :size => 10, :status => 0, :number => 1
    @table_2=Table.create! :name => '中桌', :size => 5, :status => 1, :number => 2
    @table_3=Table.create! :name => '小桌', :size => 4, :status => 2, :number => 3
    #t.integer  "table_id"
    #t.float    "sales"
    #t.integer  "status"
    #t.datetime "created_at"
    #t.datetime "updated_at"
    #t.integer  "price"
    @menu_1=Menu.create! :table_id => @table_1.id, :sales => 1.0, :status => 2, :price => 0
    @menu_4=Menu.create! :table_id => @table_1.id, :sales => 1.0, :status => 0, :price => 0
    #t.integer  "menu_id"
    #t.integer  "dish_id"
    #t.datetime "created_at"
    #t.datetime "updated_at"
    #t.integer  "amount"
    @dish_menu_1=DishMenu.create! :menu_id => @menu_1.id, :dish_id => @dish_1.id, :amount => 1
    @dish_menu_2=DishMenu.create! :menu_id => @menu_1.id, :dish_id => @dish_2.id, :amount => 1
    @dish_menu_3=DishMenu.create! :menu_id => @menu_1.id, :dish_id => @dish_3.id, :amount => 2

    @menu_2=Menu.create! :table_id => @table_2.id, :sales => 1.0, :status => 0, :price => 0
    @dish_menu_4=DishMenu.create! :menu_id => @menu_2.id, :dish_id => @dish_1.id, :amount => 1
    @dish_menu_5=DishMenu.create! :menu_id => @menu_2.id, :dish_id => @dish_2.id, :amount => 1
    @dish_menu_6=DishMenu.create! :menu_id => @menu_2.id, :dish_id => @dish_3.id, :amount => 2

    @menu_3=Menu.create! :table_id => @table_3.id, :sales => 1.0, :status => 1, :price => 100
    @dish_menu_7=DishMenu.create! :menu_id => @menu_3.id, :dish_id => @dish_1.id, :amount => 1
    @dish_menu_8=DishMenu.create! :menu_id => @menu_3.id, :dish_id => @dish_2.id, :amount => 1
    @dish_menu_9=DishMenu.create! :menu_id => @menu_3.id, :dish_id => @dish_3.id, :amount => 2


  end

  #t.integer  "number"
  #t.integer  "size"
  #t.integer  "status"
  #t.string   "name"
  #t.datetime "created_at"
  #t.datetime "updated_at"
  describe 'action index' do
    it '获取所有桌子' do
      get :index
      json_to_hash(response.body).size.should == 3
    end
  end

  describe 'action dish_list' do
    it '获取该桌的菜单' do
      get :dish_list, :table_id => @table_1.id, :menu_id => @menu_1.id
      json_to_hash(response.body)['result'].should == 1
    end
  end


  describe 'action order' do
    it '开桌' do
      get :order, :table_id => @table_1.id
      res= json_to_hash(response.body)
      res['result'].should == 1
    end

    it '桌号不存在，请先联系服务员核实！' do
      get :order, :table_id => -1
      res= json_to_hash(response.body)
      res['result'].should == 0 && res['message'].should == '桌号不存在，请先联系服务员核实！'
    end

    #it '此桌已被占用！' do
    #  get :order, :table_id => @table_2.id
    #  res= json_to_hash(response.body)
    #  res['result'].should == 0 && res['message'].should == '此桌已被占用！'
    #end

  end

  describe 'action check_out' do
    it '结账成功' do
      get :check_out, :menu_id => @menu_2.id
      res= json_to_hash(response.body)
      res['result'].should == 1
    end

    it '重复结账' do
      get :check_out, :menu_id => @menu_4.id
      res= json_to_hash(response.body)
      res['result'].should == 0 && res['message'] == '正在结账，请耐心等待！'
    end

    it '结账失败' do
      get :check_out, :menu_id => -1
      res= json_to_hash(response.body)
      res['result'].should == 0 && res['message'] =='您尚未点菜，请先提交菜单，谢谢！'
    end
  end

  describe 'action add_dish' do
    it '添加菜品成功' do
      get :add_dish, :menu_id => @menu_2.id, :dish_id => @dish_1.id
      res= json_to_hash(response.body)
      res['result'].should == 1
    end

    it '添加菜品失败' do
      get :add_dish, :menu_id => @menu_2.id
      res= json_to_hash(response.body)
      res['result'].should == 0 && res['message'].should == '添加失败，您可以呼叫服务员点菜！'
    end

    it '添加菜品失败' do
      get :add_dish, :menu_id => @menu_2.id, :dish_id => @dish_4.id
      res= json_to_hash(response.body)
      res['result'].should == 0 && res['message'].should == '此菜品已卖完，请选择其他菜品！'
    end

    it '添加菜品失败' do
      get :check_out, :menu_id => -1
      res= json_to_hash(response.body)
      res['result'].should == 0 && res['message'] == '添加失败，您可以呼叫服务员点菜！'
    end
  end

  describe 'action remove_dish' do
    it '删除菜品成功' do
      get :remove_dish, :menu_id => @menu_2.id, :dish_id => @dish_1.id
      res= json_to_hash(response.body)
      res['result'].should == 1
    end

    it '删除菜品失败' do
      get :remove_dish, :menu_id => @menu_3.id, :dish_id => @dish_1.id
      res= json_to_hash(response.body)
      res['result'].should == 0 && res['message'].should == '您已经结账，无法删除已点菜品！'
    end

    it '删除菜品失败' do
      get :remove_dish, :menu_id => @menu_4.id, :dish_id => @dish_4.id
      res= json_to_hash(response.body)
      res['result'].should == 0 && res['message'].should == '删除失败，请重试！'
    end

  end

  describe 'action verify_menu' do
    it '确认订单成功' do
      get :verify_menu, :menu_id => @menu_1.id
      res = json_to_hash(response.body)
      res['result'].should == 1 && res['message'].should == '菜单已经生效，请耐心等待！'
    end

    it '确认订单失败' do
      get :verify_menu, :menu_id => @menu_3.id
      res = json_to_hash(response.body)
      res['result'].should == 0 && res['message'].should == '您已经结账，菜单已经过期！'
    end
  end

end
