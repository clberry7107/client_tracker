class CreateTempArtist < ActiveRecord::Migration
  def change
    create_table :temp_artists do |t|
    	t.integer :ArtistID
    	t.string :ListName
    	t.integer :ArtstType
    	t.integer :MatchType
    	t.string :Genre
    	t.string :Url

    	t.timestamps
    end
  end
end
