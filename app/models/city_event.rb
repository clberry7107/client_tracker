class CityEvent < ActiveRecord::Base
	belongs_to :city
	belongs_to :event
end