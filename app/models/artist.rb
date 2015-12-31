class Artist < ActiveRecord::Base
	has_many :artist_events, dependent: :destroy	
	has_many :events, through: :artist_events
	
	def table_name
		self.table_name
	end
	
end