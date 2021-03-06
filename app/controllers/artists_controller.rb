class ArtistsController < ApplicationController
	before_action :valid_selection?, only: [:create]
	before_action :valid_artist_name?, only: [:search]
	before_action :authorized_session?
	
	helper_method :sort_column, :sort_direction
	
	def index
		#Show all saved artists
		@artists = Artist.all.order(:ListName)
	end

	def new
		@artist = Artist.new
	end

	def search
		#Search for an artist via Pollstar API
		# load results into temp_artists table
		@artists = Array.new

		#take user input and make it ready for pollstar api search string
		#MOVE THIS TO APPLICATION_CONTROLLER
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
					UserTempArtist.create({:temp_artist_id => @artists.last.id})
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
		TempArtist.delete_all
		UserTempArtist.delete_all
	end

	def edit
		@artist = Artist.find(params[:id])
	end

	def show
		#Shows artist info and list of events
		@artist = Artist.find(params[:id])
		@events = @artist.events.order(:play_date)
	end


	def update
		#Change artist status
		artist = Artist.find(params[:id])
		artist.update(client_status: artist_params[:client_status])
		artist.update(artist_url: Artist.clean_url(artist_params[:artist_url]))
		redirect_to artist_path(artist)
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
		redirect_to artists_path
	end

	private

		def artist_params
			params.require(:artist).permit(:ListName, :ArtistID, :Url, :client_status, :artist_url)
		end
		
		def sort_column
			Artist.column_names.include?(params[:sort]) ? params[:sort] : "ListName"
		end
		
		def sort_direction
			%w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
		end
		
		def sort_secondary
			params[:secondary] == ", ListName asc" ? params[:secondary] : ""	
		end
	
		#Ensures user has entered name in search field
		def valid_artist_name?
			if params[:artist].empty?
				flash[:danger] = "Please enter an artist name"
				redirect_to search_artist_path
			end
		end
	
		#Ensures user has selected artist from search results
		def valid_selection?
			if !params[:selected_artist] 
				flash[:danger] = "Please select an artist"
				redirect_to search_path(params)
			end
		end
end