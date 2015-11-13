class EventsController < ApplicationController

def index
	#Show all saved Events info
	@events = Events.all
end


def new
	#Search for artist events via Pollstar API
	# load results into temp_events table
	@event = Event.new
end


def create
	# add selected artist events to events table
	Event.create(event_params)
end



def show
	#Shows artist info and list of events
	@event = Event.find(params[:id])
	@address = get_address(@event)
	other_events = Event.where(:PlayDate => @event.PlayDate.to_date - 5..@event.PlayDate.to_date + 5)
	
	#Show related events
	@other_events = other_events.reject {|event| event.Region != @event.Region || event == @event}
	@other_events.sort_by(&:PlayDate)
	end


def update
	#Gather all artist events and compare_by_EventID to events table
	# remove old events
	# add new events to events table
end


def destroy
	#remove all selected artist events from events table
	@event = Event.find(params[:id])
end


private



end