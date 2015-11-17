class UsersController < ApplicationController
  
  before_action :require_user, only: [:show, :update]
	before_action :set_user, only: [:edit, :update]
	before_action :require_same_user, only: [:edit, :update] 
	
	def index
    @users = User.paginate(page: params[:page], per_page: 10)
	end
  
  def show
    @artists = Artist.all.order(:ListName)
    @events = Event.all.order(:PlayDate)
    @today = Date.today
    @date_range = (@today..@events.last.PlayDate.to_date)
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.create(user_params)
    
    if @user.save 
      session[:user_id] = @user.id
      flash[:success] = "Welcome to Client Tracker #{@user.fname}!"
      redirect_to user_path(current_user)
    else
      flash[:warning] = "Something went wrong, try again."
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
      if current_user != @user
        flash[:danger] = "You can only edit your own profile."
        redirect_to user_path
      end
    end


end