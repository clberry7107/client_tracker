class CreateUserTempArtist < ActiveRecord::Migration
  def change
    create_table :user_temp_artists do |t|
    	t.integer :user_id, :temp_artist_id
    	
    end
  end
end
