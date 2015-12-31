class City < ActiveRecord::Base
	has_many :city_events, dependent: :destroy	
	has_many :events, through: :city_events

	validates :CityID, uniqueness: true
	
	def table_name
		self.table_name
	end
end