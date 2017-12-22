class UtilitiesController < ApplicationController
   before_action :authorized_session?
   
   def index
      @tables = Array.new()
       
      ActiveRecord::Base.connection.tables.each do |table|
         begin
            @tables << {:name => table, :count =>  table.singularize.camelize.constantize.count} unless table == "schema_migrations"
         rescue
         end
      end
   end 
   
   def edit
       update_cal(true)
       redirect_to events_path
       
   end
    
end