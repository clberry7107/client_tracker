class UsersController < ApplicationController

	before_action :set_user, only: [:edit, :update, :show]
	before_action :require_user, except: [:new, :show, :index]
	before_action :require_same_user, only: [:edit, :update] #unless current_user.access_level == 'admin'
	
	def index
    @users = User.paginate(page: params[:page], per_page: 10)
	end
  
  def show
   
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.create(user_params)
    @user.user = current_user
    
    if @user.save 
      flash[:success] = "Welcome to Client Tracker #{user.fname}!"
      redirect_to users_path
    else
      render :new
    end
  end
  
  def edit
    
  end
  
  def update
    if @user.update(user_params) 
      flash[:success] = "Your profile was updated succesfully!"
      redirect_to user_path(@user)
    else
      render :edit
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:fname, :lname, :email, :password, :access_level, :user_type)
    end
    
    def set_user
      @user = User.find(params[:id])
    end
    
    def require_same_user
      if current_user != @user.user
        flash[:danger] = "You can only edit your own profile."
        redirect_to user_path
      end
    end

end