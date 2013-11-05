# -*- encoding : utf-8 -*-
module TablesHelper

  def display_nav_tables
    content_for :nav2 do
      html_string = "<li class=\"nav-header\"> #{NAV1[:table]} </li>"
      if  TABLE.blank?
      else
        TABLE.each do |key, value|
          html_string+="<li #{session[:table_type] == key ? 'class="active"' : '' } ><a href=\"/tables\"  onclick=\"return typeSelect(#{key})\">#{value}</a></li>"
        end
      end
      raw(html_string)

    end
  end
end
