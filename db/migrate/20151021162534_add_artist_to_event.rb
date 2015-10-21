class AddArtistToEvent < ActiveRecord::Migration
  def up
  	add_column :events, :artist_name, :string
  	add_column :events, :artist_id, :integer
  end
end
