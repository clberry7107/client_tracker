class CitiesController < ApplicationController

	# before_action :require_user
	
	
	def index
		#show cities table in state order
		if City.count == 0
			redirect_to user_path(current_user)
		end
		
		@cities = City.all.order(:CountryName, :State, :CityName)
		@us_cities = City.where.not(State: "").order(:State)
		@in_cities = City.where(State: "").order(:CountryName)
		@country = @cities.first.CountryName
		@state = @cities.first.State
	end

	def new

	end

	def show
		@city = City.find(params[:id])
		if params.has_key?(:date)
			@events = @city.events.where(PlayDate: params[:date])
		else
			@events = @city.events.where('PlayDate > ?', Date.yesterday).order(:PlayDate)
		end
		
		
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