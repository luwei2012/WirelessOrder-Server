# -*- encoding : utf-8 -*-
require 'spec_helper'
#include ActionDispatch::TestProcess
#create_table "dish_styles", force: true do |t|
#  t.string   "name"
#  t.string   "describe"
#  t.datetime "created_at"
#  t.datetime "updated_at"
#end
#
#create_table "dish_types", force: true do |t|
#  t.string   "name"
#  t.string   "describe"
#  t.datetime "created_at"
#  t.datetime "updated_at"
#end
#
#create_table "dishes", force: true do |t|
#  t.string   "name"
#  t.integer  "dish_type_id"
#  t.integer  "price"
#  t.integer  "dish_style_id"
#  t.string   "remarks"
#  t.integer  "status"
#  t.integer  "count"
#  t.string   "imageUrl"
#  t.datetime "created_at"
#  t.datetime "updated_at"
#  t.float    "sales"
#  t.integer  "cost_time"
#end

describe Mobile::MDishController do
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
  end

  describe 'action index' do
    it '获取所有菜品列表' do
      get :index
      json_to_hash(response.body).size.should == 3
    end

    it '获取特定菜品列表' do
      get :index, :dish_type => @dish_type_3.id
      json_to_hash(response.body).size.should == 1
    end

    it '获取特定菜品列表' do
      get :index, :dish_style => @dish_style_1.id
      json_to_hash(response.body).size.should == 1
    end

    it '获取特定菜品列表' do
      get :index, :dish_type => @dish_type_3.id, :dish_style => @dish_style_1.id
      json_to_hash(response.body).size.should == 1
    end
  end

  describe 'action dish_type_list' do
    it '获取所有菜品的类型列表' do
      get :dish_type_list
      json_to_hash(response.body).size.should == 3
    end
  end


  describe 'action dish_style_list' do
    it '获取所有菜系的列表' do
      get :dish_style_list
      json_to_hash(response.body).size.should == 3
    end
  end


end
