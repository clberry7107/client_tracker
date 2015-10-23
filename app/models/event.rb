class Event < ActiveRecord::Base
	has_many :city_events, dependent: :destroy
	
end