class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  @@last_cal_update = Date.yesterday
  

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

  #Pollstar.com API key
  def ps_key
    "&apiKey=22300-7812380"
  end

  #Test when the database was last updated
  def updated_today?
    Date.today == @@last_cal_update
  end
  
  def last_updated
    @@last_cal_update
  end

  #Clears and updates Event table
  def update_cal
    if !updated_today?
      Event.destroy_all
      CityEvent.destroy_all
      ArtistEvent.destroy_all
      
      Artist.all.each do |artist|
        get_events(artist)
      end
      
      all_events = Event.all.order(:PlayDate)
      corelated_dates((all_events.first.PlayDate.to_date..all_events.last.PlayDate.to_date), all_events)
      @@last_cal_update = Date.today
    end
  end

  #Fetch artist events from Pollstar.com API
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
      event.PlayDate = Date.parse(ne.attribute('PlayDate').to_s.gsub(/, */, '-'))
      event.Playtime = ne.attribute('PlayTime').to_s
      event.Url = ne.attribute('Url').to_s
      event.artist_name = artist.ListName
      event.artist_id = artist.id
      
      # Ensure CountryName valide and present
      city.ensure_CountryName
      event.ensure_CountryName
      
      # Verify / Add city to city table
      city = City.find_by CityID: city.CityID unless city.save
      event.city_id = city.id
      event.save
      
      # Create link table entries
      ArtistEvent.create({:artist => artist, :event => event})
      CityEvent.create({:city => city, :event => event})
    end
  end

  #Fetch venue address form Pollstar.com API
  def get_address(event)
    this_uri = "http://data.pollstar.com/api/pollstar.asmx/VenueEvents?venueID=#{event.VenueID}&startDate=#{Time.now.strftime("%m/%d/%Y")}&dayCount=0&page=0&pageSize=0#{ps_key}"

    doc = Nokogiri::XML(Net::HTTP.get(URI(this_uri)))
    venue = doc.xpath("//VenueInfo")
    address =  Address.new(event.id) 
    address.address1 = venue.attribute('Address1')
    address.address2 = venue.attribute('Address2')
    address.zip = venue.attribute('Zip')

    return address
  end
  
  def corelated_dates(date_range, events)
    corelated_events = Array.new
       
    events.each do |event|
      count = 0
      events.each do |compare|
        if event.PlayDate == compare.PlayDate && event.Region == compare.Region
          count += 1
        end
      end
        
      if count > 1
        coralation = {:date => event.PlayDate.to_date, :region_id => event.city_id, :region => event.Region}
        corelated_events << coralation unless corelated_events.include?(coralation)
      end
    end
    
    return corelated_events
  end
  
  def access_levels
    [[current_user.access_level, current_user.access_level], ['guest', 'guest'], ['user', 'user'], ['admin', 'admin']]
  end
  
  def user_types
    [[current_user.user_type, current_user.user_type], ['Technician', 'Technician'], ['Sales', 'Sales'], ['Project Management', 'Project Management'],['Administration', 'Administration']]
  end
  
  
end
