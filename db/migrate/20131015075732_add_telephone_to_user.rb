# -*- encoding : utf-8 -*-
class AddTelephoneToUser < ActiveRecord::Migration
  def change
    add_column :users, :phone, :string
  end
end
