class UtilitiesController < ApplicationController
   
   def index
       @tables = Array.new()
       
       ActiveRecord::Base.connection.tables.each do |table|
           @tables << {:name => table, :count =>  table.singularize.camelize.constantize.count} unless table == "schema_migrations"
        end
   end 
   
   def edit
       update_cal
       redirect_to events_path
       
   end
    
end