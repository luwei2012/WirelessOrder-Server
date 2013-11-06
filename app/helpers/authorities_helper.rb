# -*- encoding : utf-8 -*-
module AuthoritiesHelper

  def display_authorities(t)
    content_for :nav2 do

      raw("<li class=\"nav-header\">分类</li>
           <li #{t == USER_ROLE_NAME[:all] ? 'class="active"' : '' } ><a href=\"/authorities\">#{ USER_ROLE_NAME[:all] }</a></li>
           <li #{t == USER_ROLE_NAME[:normal_admin] ? 'class="active"' : '' } ><a href=\"/authorities?role_id=#{User::NORMAL_ADMIN}\">#{ USER_ROLE_NAME[:normal_admin] }</a></li>
           <li #{t == USER_ROLE_NAME[:super_admin] ? 'class="active"' : '' } ><a href=\"/authorities?role_id=#{User::SUPER_ADMIN}\">#{ USER_ROLE_NAME[:super_admin] }</a></li>
           <li #{t == USER_ROLE_NAME[:normal_user] ? 'class="active"' : '' } ><a href=\"/authorities?role_id=#{User::NORMAL_USER}\">#{ USER_ROLE_NAME[:normal_user] }</a></li>
        ")

    end
  end

  def display_user_info
    content_for :nav2 do

      raw("<li class=\"nav-header\">用户信息</li>
           <li class= active ><a href=\"/authorities/#{params[:id]}\">用户信息</a></li>
          ")

    end
  end

end
