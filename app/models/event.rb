class Event < ActiveRecord::Base
	has_many :artist_events, dependent: :destroy
	has_many :artists, through: :artist_events

end