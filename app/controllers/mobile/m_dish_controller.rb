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

  def dish_style_list
    @list = DishStyle.order('id desc')
    render :json => @list.to_json(:include => {:dishes => {:except => [:created_at, :updated_at]}}, :except => [:created_at, :updated_at])
  end

end
