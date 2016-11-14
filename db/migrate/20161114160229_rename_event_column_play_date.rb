class RenameEventColumnPlayDate < ActiveRecord::Migration
  def change
    change_table :events do |t|
  		t.rename :PlayDate, :play_date
  	end
  end
end
