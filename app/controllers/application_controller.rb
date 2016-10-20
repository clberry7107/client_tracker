class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include UpdateHelper
  
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?, :require_user, :ps_key, :update_cal, :last_updated
  helper_method :get_events, :get_address, :corelated_events, :access_levels, :user_types
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    
  end
  
  def logged_in?
    !!current_user
  end
  
  def require_user
    if !logged_in?
      flash[:danger] = "Something went wrong with you log in. Please sign in."
      redirect_to root_path
    end
  end
  
  def authorized_session?
    start = Time.parse(session[:start_time])
    duration = ((Time.now - start)  / 60 ) 
    duration = duration / 60
    
    relog = ""
    
    if duration > 6
      relog = relog + "/?key=" + ENV['PASSKEY']
    elsif session[:authorized]
      return true
    end
    
    redirect_to relog
  end 

  #Pollstar.com API key
  def ps_key
    ENV['POLLSTAR_API_KEY']
  end

  #Test when the database was last updated
  def updated_today?
    Date.today.day == DateTime.parse(ENV['LAST_UPDATE']).day
  end
  
  def last_updated
    @@last_cal_update = ENV['LAST_UPDATE']
  end
  
  def access_levels
    [[current_user.access_level, current_user.access_level], ['guest', 'guest'], ['user', 'user'], ['admin', 'admin']]
  end
  
  def user_types
    [[current_user.user_type, current_user.user_type], ['Technician', 'Technician'], ['Sales', 'Sales'], ['Project Management', 'Project Management'],['Administration', 'Administration']]
  end
  
  
end
