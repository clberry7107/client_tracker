class Event < ActiveRecord::Base
	has_many :city_events, dependent: :destroy
	
	before_save :ensure_CountryName
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
	
	#VALIDATE / CREATE CountryName for all events
	def ensure_CountryName
		if self.CountryName == ""
			self.CountryName = "United States"
		end
		if ["AB", "BC", "MB", "NB"].include?(self.State)
			self.CountryName = "Canada"
		end
	end

end