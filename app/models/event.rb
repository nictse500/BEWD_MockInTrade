class Event < ActiveRecord::Base
	has_many :orders
	has_many :users, through: :orders
	self.inheritance_column = :sti_type
end
