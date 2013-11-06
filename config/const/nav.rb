# -*- encoding : utf-8 -*-
ZONE_8_OFFSET = -ActiveSupport::TimeZone[8.0].utc_offset


ERROR =
    {
        :shopping_error => 901,
        :normal => 900,
        :new_version => 902,
        :server_maintain => 903,
        :download_latest_version => 999,
        :over_3_account => 998,
        :session_error => 997,
    }


MY_KEY = '3da541559918a808c2402bba5012f6c60b27661c' # 用于用户密码加密


CLIENT_TYPE = {
    :iOS => 0,
    :Android => 1,
    :PC => 2,
}

NAV1 = {
    :table => '餐桌管理',
    :dish => '菜品管理',
    :dish_style => '菜系管理',
    :dish_type => '菜品类别',
    :authority => '管理员',
}

NAV2 = {
    :all => '全部',
    :leisure => '空闲',
    :token => '占用',
    :reserve => '预定',

}


#shop
TABLE ={
    -1 => '全部',
    0 => '空闲',
    1 => '占用',
    2 => '预定',
}
#status 0:缺货
#       1:可点
DISH ={
    0 => '缺货',
    1 => '可点',
}
#user
USER ={
    :all => '所有用户',
    :all_integral => '用户积分',
}

#定义用户角色
USER_ROLE_NAME = {
    :all => '所有',
    :super_admin => '超级管理员',
    :normal_admin => '管理员',
    :normal_user => '普通用户',
}

#定义用户角色
ROLE_NAME = {
    2 => '超级管理员',
    1 => '管理员',
    0 => '普通用户',
}

#缩略图尺寸
class THUMBNAIL_SIZE
  def self.middle_width
    return 413
  end

  def self.middle_height
    return 620
  end

  def self.large_width
    return 600
  end

  def self.large_height
    return 800
  end

  def self.small_width
    return 270
  end

  def self.small_height
    return 200
  end
end

#迈普云域名
ROOT_URL = 'http://localhost:3000'

#访问的客户端类型
ANDROID = 1
IPHONE = 2

