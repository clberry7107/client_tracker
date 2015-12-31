class Event < ActiveRecord::Base
	has_many :city_events, dependent: :destroy

	validates :EventID, uniqueness: true
	
	#had issues with 'belongs_to'.  these are a workaround
	def artist
		Artist.find(artist_id)
	end
	
	def city
		City.find(city_id)
	end
	
	def table_name
		self.table_name
	end

end