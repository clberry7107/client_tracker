class ArtistEvent < ActiveRecord::Base
	belongs_to :artist
	belongs_to :event
end