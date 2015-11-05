class ArtistsController < ApplicationController
	before_action :valid_selection?, only: [:create]
	before_action :valid_artist_name?, only: [:search]

	def index
		#Show all saved artist info
	end

	def new
		@artist = Artist.new
	end

	def search
		#Search for an artist via Pollstar API
		# load results into temp_artists table
		@artists = Array.new

		#take user input and make it ready for pollstar api search string
		if params[:type] == "Search" 
			@artist = TempArtist.new(:ListName => params[:artist])
			@name = @artist.ListName.gsub " ", "%20"

			this_uri = "http://data.pollstar.com/api/pollstar.asmx/Search?searchText=#{@name}#{ps_key}"
			this_uri.gsub! " ", ""

			#query pollstar and save results as xml object
			doc = Nokogiri::XML(Net::HTTP.get(URI(this_uri)))
			@all_artists = doc.xpath("//Artists//Artist")

			
			#filter results by MatchType and send array list to view for display
				@all_artists.each do |a|
				match_type = a.attribute('Matchtype')
				if match_type.to_i < 3 
					artistID = a.attribute('ID').to_s
					@artists << TempArtist.create({:ListName => a.attribute('ListName').to_s, :ArtistID => artistID.to_i, :Genre => a.attribute('Genre'), :Url => a.attribute('Url')})
					UserTempArtist.create({:temp_artist_id => @artists.last.id, :user_id => current_user.id})
				end
			end
		else
			@artist = TempArtist.new({:ListName => params[:artist]})
			current_user.temp_artists.each {|ta| @artists << ta}
		end
	end

	def create
		#When search result are confirmed,
		ta = TempArtist.find_by(ArtistID: params[:selected_artist])

		#check if search artist exists in Artist table
		# add selected artist to artists table
		@artist = Artist.find_by(ArtistID: ta.ArtistID) || @artist = Artist.create({:ArtistID => ta.ArtistID, :ListName => ta.ListName, :Url => ta.Url})
			
		redirect_to edit_artist_path(@artist)
		get_events(@artist)
		artists = current_user.temp_artists
		artists.each{|a| TempArtist.find(a).delete}
		current_user.temp_artists.delete_all
	end

	def edit
		@artist = Artist.find(params[:id])
	end

	def show
		#Shows artist info and list of events
		@artist = Artist.find(params[:id])
		@events = @artist.events.order(:PlayDate)
	end


	def update
		#Change artist status
		artist = Artist.find(params[:id])
		artist.update(client_status: artist_params[:client_status])
		redirect_to user_path(current_user)
	end

	def destroy
		#remove artist from artists table
		artist = Artist.find(params[:id])	
		artist.events.each do |e|
			e.city_events.delete_all
			Event.delete(e)
		end
		artist.events.delete_all
		artist.delete
		redirect_to user_path(current_user)
	end

	private

	def artist_params
		params.require(:artist).permit(:ListName, :ArtistID, :Url, :client_status)
	end

	def valid_artist_name?
		if params[:artist].empty?
			flash[:danger] = "Please enter an artist name"
			redirect_to search_artist_path
		end
	end

	def valid_selection?
		if !params[:selected_artist] 
			flash[:danger] = "Please select an artist"
			redirect_to search_path(params)
		end
	end
end