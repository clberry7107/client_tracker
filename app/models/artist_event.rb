class ArtistEvent < ActiveRecord::Base
	belongs_to :artist
	belongs_to :event
	
	def table_name
		self.table_name
	end
end