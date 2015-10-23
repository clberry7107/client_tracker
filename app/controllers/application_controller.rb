class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  @@last_cal_update = Date.yesterday

  helper_method :current_user, :logged_in?, :require_user, :ps_key, :update_cal, :last_updated
  helper_method :get_events

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def logged_in?
    !!current_user
  end
  
  def require_user
    if !logged_in?
      flash[:danger] = "You must be logged in to perform that action"
      redirect_to root_path
    end
  end

  def ps_key
    "&apiKey=22300-7812380"
  end

  def updated_today?
    Date.today == @@last_cal_update
  end

  def last_updated
    @@last_cal_update
  end

  def update_cal
    if !updated_today?
      Event.delete_all

      Artist.all.each do |artist|
        get_events(artist)
      end

      @@last_cal_update = Date.today
    end
  end

  def get_events(artist)
    this_uri = "http://data.pollstar.com/api/pollstar.asmx/ArtistEvents?artistID=#{artist.ArtistID}&startDate=#{Time.now.strftime("%m/%d/%Y")}&dayCount=0&page=0&pageSize=0#{ps_key}"
    this_uri.gsub! " ", ""

    doc = Nokogiri::XML(Net::HTTP.get(URI(this_uri)))
    all_artist_events = doc.xpath("//ArtistInfo//Events/Event")  

    all_artist_events.each do |ne|
      event = Event.new
      city = City.new
      event.EventID = ne.attribute('EventID').to_s
      event.EventName = ne.attribute('EventName').to_s
      event.VenueID = ne.attribute('VenueID').to_s
      event.VenueName = ne.attribute('VenueName').to_s
      event.CityID = ne.attribute('CityID').to_s
      city.CityID = ne.attribute('CityID').to_s
      event.CityName = ne.attribute('CityName').to_s
      city.CityName = ne.attribute('CityName').to_s
      event.State = ne.attribute('State').to_s
      city.State = ne.attribute('State').to_s
      event.CountryName = ne.attribute('CountryName').to_s
      city.CountryName = ne.attribute('CountryName').to_s
      event.Region = ne.attribute('Region').to_s
      city.Region = ne.attribute('Region').to_s
      event.PlayDate = ne.attribute('PlayDate').to_s
      event.Playtime = ne.attribute('PlayTime').to_s
      event.Url = ne.attribute('Url').to_s
      event.artist_name = artist.ListName
      event.artist_id = artist.id
      event.save
      city = City.find_by CityID: city.CityID unless city.save

      ArtistEvent.create({:artist => artist, :event => event})
      CityEvent.create({:city => city, :event => event})
    end
  end
end
