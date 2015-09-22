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

		#Empty the temp_artist table
		Temp_Artist.delete_all
		#take user input and make it ready for pollstar api search string
		@artist = Temp_Artist.new(artist_params)
		if @artist.ListName.include?		(' ')
			@name = @artist.ListName.gsub " ", "%20"
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
				artistID = a.attribute('ID').to_s
				this_artist = Temp_Artist.create({:ListName => a.attribute('ListName').to_s, :ArtistID => artistID.to_i, :Genre => a.attribute('Genre'), :Url => a.attribute('Url')})
			end
		end
		Temp_Artist.all.each do |a|
			@artists << a
		end
	end

	def create
		#When search result are confirmed,
		# add selected artist to artists table
		ta = Temp_Artist.find_by(ArtistID: params[:artist])
		@artist = Artist.find_by(ArtistID: ta.ArtistID) || @artist = Artist.create({:ArtistID => ta.ArtistID, :ListName => ta.ListName, :Url => ta.Url})

		redirect_to edit_artist_path(@artist)
	end

	def edit
		@artist = Artist.find(params[:id])
	end

	def show
		#Shows artist info and list of events
		
		@artist = Artist.find(params[:id])

	end


	def update
		#Change artist status
		artist = Artist.find(params[:id])
		artist.update(client_status: artist_params[:client_status])
		redirect_to user_path(current_user)
	end


	def destroy
		#remove artist from artists table
	end


	private

	def artist_params
		params.require(:artist).permit(:ListName, :ArtistID, :Url, :client_status)
	end


end
