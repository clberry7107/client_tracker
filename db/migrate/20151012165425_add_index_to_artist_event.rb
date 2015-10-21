class AddIndexToArtistEvent < ActiveRecord::Migration
  def change
  end

  add_index :artist_events, :artist_id
  add_index :artist_events, :event_id
end
