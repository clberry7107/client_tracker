class CityEvent < ActiveRecord::Base
	belongs_to :city
	belongs_to :event
	
	def table_name
		self.table_name
	end
end