class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :type
      t.decimal :price
      t.integer :shares
      t.integer :user_id
      t.integer :event_id
      t.boolean :filled

      t.timestamps
    end
  end
end
