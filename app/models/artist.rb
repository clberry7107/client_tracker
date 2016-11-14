class Artist < ActiveRecord::Base
	has_many :artist_events, dependent: :destroy	
	has_many :events, through: :artist_events
	
	def table_name
		self.table_name
	end
	
	def f_artist_url
		if !self.artist_url.nil?
			header = "http://www."
			header << self.artist_url
		else
			header = ""
		end
		
		return header
	end
	
	def self.clean_url(artist_url)
		cleaned = ""
		if artist_url.include?("http://") 
			cleaned = artist_url.sub!('http://', "")
		end
		if artist_url.include?("www.")
			cleaned = cleaned.sub!('www.', "")
		end
		return cleaned
	end
	
end