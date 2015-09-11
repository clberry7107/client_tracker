class CreateArtist < ActiveRecord::Migration
  def change
    create_table :artists do |t|
    	t.integer :ArtistID
    	t.string :ListName
    	t.string :Url
    	t.string :status

    	t.timestamps
    end
  end
end
