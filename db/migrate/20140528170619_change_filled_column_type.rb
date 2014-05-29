class ChangeFilledColumnType < ActiveRecord::Migration
  def change
  	change_column :orders, :filled, :integer
  end
end
