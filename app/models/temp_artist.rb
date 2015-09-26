class Temp_Artist < ActiveRecord::Base
	has_many :user_temp_artist, dependent: :destroy
	has_many :users, through: :user_temp_artists

end