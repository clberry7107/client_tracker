class PagesController < ApplicationController

	def home
		# if logged_in?
		# 	redirect_to user_path(current_user)
		# end
		session[:authorized] = nil
		
		if params[:key] == ENV['PASSKEY']
			session[:authorized] = :true
			redirect_to events_path
		end
		
		#show home page
		
	end


	
end