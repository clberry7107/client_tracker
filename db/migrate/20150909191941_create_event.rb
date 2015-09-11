class CreateEvent < ActiveRecord::Migration
  def change
    create_table :events do |t|
    	t.integer :EventID
    	t.string :EventName
    	t.integer :VenueID
    	t.string :VenueName
    	t.integer :CityID
    	t.string :CityName
    	t.string :State
    	t.string :CountryName
    	t.string :Region
    	t.string :PlayDate
    	t.string :Playtime
    	t.string :Url
    	t.integer :Venue_lat
    	t.integer :Venue_long

    	t.timestamps
    end
  end
end
