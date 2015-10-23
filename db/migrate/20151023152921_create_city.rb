class CreateCity < ActiveRecord::Migration
  def change
    create_table :cities do |t|
    	t.integer :CityID
    	t.string :CityName
    	t.string :State
    	t.string :Region
    	t.float :latitude
    	t.float :longitude

    	t.timestamps
    end
  end
end
