class UserTempArtist < ActiveRecord::Base
	belongs_to :user
	belongs_to :temp_artist #ADD DEPENDENT: :DESTROY?
	
	
	def table_name
		self.table_name
	end

end 