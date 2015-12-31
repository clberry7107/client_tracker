class UtilitiesController < ApplicationController
   
   def show
       @tables = Array.new()
       
       ActiveRecord::Base.connection.tables.each do |table|
           @tables << {:name => table, :count =>  table.singularize.camelize.constantize.count} unless table == "schema_migrations"
        end
 
   
   end 
    
end