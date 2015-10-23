class CreateCityEvents < ActiveRecord::Migration
  def change
    create_table :city_events do |t|
    	t.integer :city_id
    	t.integer :event_id

    	t.belongs_to :city, index: true
    	t.belongs_to :event, index: true

    	t.timestamps
    end
  end
end
