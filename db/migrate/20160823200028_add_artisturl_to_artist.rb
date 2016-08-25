class AddArtisturlToArtist < ActiveRecord::Migration
  def change
    add_column :artists, :artist_url, :string
  end
end
