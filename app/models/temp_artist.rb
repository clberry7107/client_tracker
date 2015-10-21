class TempArtist < ActiveRecord::Base
	belongs_to :user_temp_artist
	has_one :user, through: :user_temp_artists

end