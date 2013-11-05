# -*- encoding : utf-8 -*-
class CreateTables < ActiveRecord::Migration
  def change
    create_table :tables do |t|
      t.integer :number
      t.integer :size
      t.integer :status
      t.string :name

      t.timestamps
    end
  end
end
