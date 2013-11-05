# -*- encoding : utf-8 -*-
#格式化时间
def format_datetime(aDatetime)
  if aDatetime
    aDatetime.strftime('%Y-%m-%d %H:%M:%S')
  else
    ''
  end
end

#格式化日期
def format_date(aDatetime)
  if aDatetime
    aDatetime.strftime('%Y-%m-%d')
  else
    ''
  end
end

#格式化日期(月.日)
def format_date_yd(aDatetime)
  if aDatetime
    aDatetime.strftime('%m.%d')
  else
    ''
  end
end

def random_string
  (('a'..'z').to_a+(0..9).to_a+('A'..'Z').to_a).shuffle[0,11].join
end

def random_intCode
  ((0..9).to_a+(0..9).to_a+(0..9).to_a+(0..9).to_a+(0..9).to_a).shuffle[0,4].join
end

def change_datasource
  ActiveRecord::Base.establish_connection(
      :adapter  =>"mysql2",
      :host     =>"localhost",
      :username =>"root",
      :password =>"",
      :database =>"maipuyun2"
  )
end


class Cloud
  def self.default_datasource
    ActiveRecord::Base.establish_connection(
        :adapter  =>"mysql2",
        :host     =>"localhost",
        :username =>"root",
        :password =>"",
        :database =>"maipuyun"
    )
  end

  def self.create_database
    new_database = {
        :adapter  =>"mysql2",
        :host     =>"localhost",
        :username =>"root",
        :password =>"",
        :database =>"maipuyun2www"
    }

    ActiveRecord::Base.connection.create_database(new_database[:database])
  end


  def self.migrate_database
    begin
      original = ActiveRecord::Base.remove_connection
      ActiveRecord::Base.establish_connection(
          :adapter  =>"mysql2",
          :host     =>"localhost",
          :username =>"root",
          :password =>"",
          :database =>"maipuyun2www"
      )

      ActiveRecord::Migrator.migrate("#{Rails.root}/db/migrate", ENV['VERSION'].try(:to_i))
    ensure
      ActiveRecord::Base.establish_connection original
    end

  end

end
