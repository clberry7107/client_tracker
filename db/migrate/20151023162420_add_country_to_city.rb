class AddCountryToCity < ActiveRecord::Migration
  def change
  	add_column :cities, :CountryName, :string
  end
end
