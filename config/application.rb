# -*- encoding : utf-8 -*-
require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

class ActiveRecord::Base
  # 转化为hash，保留想要的，或者去除不想要的
  # t = Town.find 1
  # t.to_hash(:drop => %w(created_at updated_at))
  # t.to_hash(:keep => %w(created_at updated_at))
  # t.to_hash
  # t.to_hash :keep => "created_at"
  def to_hash(params = {})
    h = attributes
    h.symbolize_keys!
    if params[:drop]
      params[:drop].each { |s| h.delete(s.to_sym) }
    end
    if params[:keep]
      h.delete_if { |k, v| not params[:keep].include?(k.to_sym) }
    end
    h.each { |k, v|
      h[k] = v.to_i if h[k].class == ActiveSupport::TimeWithZone
      if h[k].blank?
        k.to_s.include?('_id') ? h.delete(k) : h[k] = v.to_s
      end
    }
    return h
  end


end


module WirelessOrder
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

  end
end

#Encoding.default_external = "utf-8"
Dir.glob(File.dirname(__FILE__) + '/const/*.rb') { |file| require file }
WillPaginate.per_page = 25


module WillPaginate
  module ViewHelpers
#自己修改的ajax版本
    def will_paginate_remote(paginator, options={})
      update = options.delete(:update)
      url = options.delete(:url)
      str = will_paginate(paginator, options)
      if str != nil
        str.gsub(/href="(.*?)"/) do
          "href=\"#\" onclick=\"new Ajax.Updater('" + update + "', '" + (url ? url + $1.sub(/[^\?]*/, '') : $1) +
              "', {asynchronous:true, evalScripts:true, method:'get'}); return false;\""
        end
      end
    end
  end
end
