class City < ActiveRecord::Base
	has_many :city_events, dependent: :destroy	
	has_many :events, through: :city_events
end