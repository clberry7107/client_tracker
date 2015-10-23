class CitiesController < ApplicationController


	def index
		@cities = City.all.order(:State)
		@state = @cities.first.State
	end

	def new

	end

	def show
		@city = City.find(params[:id])
		@events = @city.events.order(:PlayDate)
		@date = Date.today
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