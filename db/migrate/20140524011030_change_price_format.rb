class ChangePriceFormat < ActiveRecord::Migration
  def change
  	change_column :order, :price, :float
  end
end
