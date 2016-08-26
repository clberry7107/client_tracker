class City < ActiveRecord::Base
	has_many :city_events, dependent: :destroy	
	has_many :events, through: :city_events

	validates :CityID, uniqueness: true
	
	def table_name
		self.table_name
	end
	
	#VALIDATE/CREATE CountryName for city as when artist is created/updated
	def ensure_CountryName
		if self.State == ""
			self.CountryName = "United States"
		end
		if ["AB", "BC", "MB", "NB"].include?(self.State)
			self.CountryName = "Canada"
		end
	end
end