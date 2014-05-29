class Order < ActiveRecord::Base
	belongs_to :user
	belongs_to :event
	self.inheritance_column = :sti_type
	
	validates :shares, presence: true
	validates :shares, numericality: { only_integer: true }
	validates :price, presence: true
	validates :price, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10}
end
