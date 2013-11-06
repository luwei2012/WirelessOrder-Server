# -*- encoding : utf-8 -*-
module DishesHelper
  def display_nav_dishes
    content_for :nav2 do
      html_string = "<li  class=\"nav-header\" > #{NAV1[:dish_type]} </li>"
      if  @type_list.blank?
      else
        @type_list.each do |l|
          html_string+=" <li #{l.id == session[:dish_type] ? 'class="active"' : '' } ><a href=\"/dishes\" onclick=\"return typeSelect(#{l.id})\">#{l.name }</a></li>"
        end
      end
      raw(html_string)

    end
  end
end
