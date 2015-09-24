class CreateArtistEvents < ActiveRecord::Migration
  def change
    create_table :artist_events do |t|
    	t.integer :artist_id, :event_id
    end
  end
end
