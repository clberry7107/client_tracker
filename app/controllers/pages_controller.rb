class PagesController < ApplicationController

	def home
		# if logged_in?
		# 	redirect_to user_path(current_user)
		# end
		
		if params[:key] == "5450Avion"
			redirect_to user_path(current_user)
		end
		
		#show home page
		
	end


	
end