class CitiesController < ApplicationController

	before_action :require_user
	
	
	def index
		if City.count == 0
			redirect_to user_path(current_user)
		end
		
		@cities = City.all.order(:State)
		@state = @cities.first.State unless @cities.count == 0
	end

	def new

	end

	def show
		@city = City.find(params[:id])
		@events = @city.events.order(:PlayDate)
	end

	def create

	end

	def update

	end

	def destroy

	end

	private

	def city_params

	end

end