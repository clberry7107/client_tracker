class UserTempArtist < ActiveRecord::Base
	belongs_to :user
	belongs_to :temp_artist #ADD DEPENDENT: :DESTROY?

end 