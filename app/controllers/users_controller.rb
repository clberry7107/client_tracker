class UsersController < ApplicationController

	before_action :set_user, only: [:edit, :update, :show, :correlate]
	before_action :require_same_user, only: [:edit, :update] #unless current_user.access_level == 'admin'
	
	def index
    @users = User.paginate(page: params[:page], per_page: 10)
	end
  
  def show
    @artists = Artist.all
    @events = Event.all.order(:PlayDate)
    @date = Date.today
    if Event.last then (@last_date = Event.last.PlayDate || Date.today) end
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

  def correlate
    @artists = Artist.all
    #@events = Event.all.order(:PlayDate)
    @events = nil
    @date = Date.today
    if Event.last then (@last_date = Event.last.PlayDate || Date.today) end
    render :show
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