class RenameArtistColumnStatus < ActiveRecord::Migration
  def change
  	change_table :artists do |t|
  		t.rename :status, :client_status
  	end
  end
end
