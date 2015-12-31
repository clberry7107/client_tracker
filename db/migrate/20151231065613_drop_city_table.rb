class DropCityTable < ActiveRecord::Migration
  def change
    drop_table :city_tables
  end
end
