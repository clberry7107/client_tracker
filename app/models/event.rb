class Event < ActiveRecord::Base
	has_many :city_events, dependent: :destroy

	validates :EventID, uniqueness: true

	def artist
		Artist.find(artist_id)
	end

	def city
		City.find(city_id)
	end

end