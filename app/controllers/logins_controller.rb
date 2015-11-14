class LoginsController < ApplicationController

	def new
		
	end

	def create
		user = User.find_by(email: params[:email])

		if user && user.authenticate(params[:password])
			session[:user_id] = user.id
			flash[:success] = "Welcome back!"
			update_cal
			redirect_to user_path(user.id)
		else
			flash.now[:danger] = "Your email and password do not match our records"
			render 'new'
		end
	end

	def destroy
		session[:user_id] = nil
		flash[:success] = "Goodbye, for now."
		redirect_to root_path
	end


end