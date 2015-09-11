require 'net/http'

class ArtistsController < ApplicationController

def index
	#Show all saved artist info
end


def new
	@artist = Artist.new
end

def search
	#Search for an artist via Pollstar API
	# load results into temp_artists table

	#take user input and make it ready for pollstar api search string
	@artist = Artist.new(artist_params)
	if @artist.ListName.include?		(' ')
		@name = @artist.ListName.gsub! " ", "%20"
	else
		@name = @artist.ListName
	end

	this_uri = "http://data.pollstar.com/api/pollstar.asmx/Search?searchText=#{@name}#{ps_key}"
	this_uri.gsub! " ", ""

	#query pollstar and save results as xml object
	doc = Nokogiri::XML(Net::HTTP.get(URI(this_uri)))
	@all_artists = doc.xpath("//Artists//Artist")
	
	#filter results by MatchType and send array list to view for display
	@artists = Array.new
	@all_artists.each do |a|
		if a.attribute('MatchType').to_s == 1.to_s || a.attribute('MatchType').to_s == 2.to_s
			this_artist = Temp_Artist.create({:ListName => a.attribute('ListName').to_s, :ArtistID => a.attribute('ID'), :Genre => a.attribute('Genre'), :Url => a.attribute('Url')})
			@artists << this_artist
		end
	end
end

def create
	#When search result are confirmed,
	# add selected artist to artists table
end



def show
	#Shows artist info and list of events
end


def update
	#Change artist status
end


def destroy
	#remove artist from artists table
end


private

def artist_params
	params.require(:artist).permit(:ListName, :ArtistID, :Url, :status)
end


end