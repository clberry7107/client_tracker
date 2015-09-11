class LoginsController < ApplicationController

	def new
		
	end

	def create
		user = User.find_by(email: params[:email])

		if user && user.authenticate(params[:password])
			session[:user_id] = user.id
			flash[:success] = "Welcome back!"
			redirect_to user_path(user.id)
		else
			flash.now[:danger] = "Your email of password does not match"
			render 'new'
		end
	end

	def destroy
		session[:user_id] = nil
		flash[:success] = "Goodbye, for now."
		redirect_to root_path
	end


end