# -*- encoding : utf-8 -*-
module DishesHelper
  def display_nav_dishes
    content_for :nav2 do
      count=0
      html_string = "<li  class=\"nav-header\" > #{NAV1[:dish_type]} </li>"
      if  @type_list.blank?
      else
        @type_list.each do |l|
          html_string+=" <li #{count == session[:dish_type] ? 'class="active"' : '' } ><a href=\"/dishes\" onclick=\"return typeSelect(#{count})\">#{l.name }</a></li>"
          count+=1
        end
      end
      raw(html_string)

    end
  end
end
