class DropArtistEvent < ActiveRecord::Migration
  def change
  	drop_table :artist_events
  end
end
