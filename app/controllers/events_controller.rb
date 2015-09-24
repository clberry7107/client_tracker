class EventsController < ApplicationController

def index
	#Show all saved Events info
end


def new
	#Search for artist events via Pollstar API
	# load results into temp_events table
	this_uri = "http://data.pollstar.com/api/pollstar.asmx/ArtistEvents?artistID=#{params[ArtistID]}&startDate=#{Time.now.strftime("%m/%d/%Y")}&dayCount=0&page=0&pageSize=0&apiKey=22300-7812380"
	this_uri.gsub! " ", ""

end


def create
	# add selected artist events to events table
end



def show
	#Shows artist info and list of events
end


def update
	#Gather all artist events and compare_by_EventID to events table
	# add new events to events table
end


def destroy
	#remove all selected artist events from events table
end


private



end