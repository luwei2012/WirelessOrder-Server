# -*- encoding : utf-8 -*-
module ApplicationHelper
  def display_header(t)
    content_for :nav do
      to_all = raw("
                   <li #{t == NAV1[:table] ? 'class="active"' : '' } >
                     <a href=\"/tables\">#{ NAV1[:table] }</a>
                   </li>
<li #{t == NAV1[:dish] ? 'class="active"' : '' } >
                     <a href=\"/dishes\">#{ NAV1[:dish] }</a>
                   </li>
                 ")
      #admin_info =     raw("
      #              <li #{t == NAV1[:admin_info] ? 'class="active"':'' }>
      #                <a href=\"/authorities/#{session[:user_id]}\">#{ NAV1[:admin_info] }</a>
      #              </li>
      #            ")
      if session[:account] == "luwei"
        to_super_admin = raw("
                   <li #{t == NAV1[:authority] ? 'class="active"' : '' }>
                     <a href=\"/authorities\">#{ NAV1[:authority] }</a>
                   </li>
                 ")
        to_all +to_super_admin


      else
        to_all

      end
    end
  end


end
