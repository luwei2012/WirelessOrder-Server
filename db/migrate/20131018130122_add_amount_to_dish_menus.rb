class AddAmountToDishMenus < ActiveRecord::Migration
  def change
    add_column :dish_menus, :amount, :integer
  end
end
