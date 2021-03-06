module UpdateHelper
    
  #Clears and updates Event table
  def update_cal(force)
    if !updated_today? || force
      
      p_events = Event.all.where("play_date < ?", Date.today.to_s)
      p_events.each do |pe|
        CityEvent.where(event_id: pe.EventID).destroy_all
        ArtistEvent.where(event_id: pe.EventID).destroy_all
      end
      p_events.destroy_all
      
      
      
      Artist.all.each do |artist|
        get_events(artist)
      end
      
      all_events = Event.all.order(:play_date)
      if all_events.count > 0
        corelated_dates((all_events.first.play_date.to_date..all_events.last.play_date.to_date), all_events)
      end
      est = DateTime.now.in_time_zone('America/New_York')
      ENV['LAST_UPDATE'] = est.to_s
    end
  end

  #Fetch artist events from Pollstar.com API
  def get_events(artist)
    this_uri = "http://data.pollstar.com/api/pollstar.asmx/ArtistEvents?artistID=#{artist.ArtistID}&startDate=#{Time.now.strftime("%m/%d/%Y")}&dayCount=0&page=0&pageSize=0#{ps_key}"
    this_uri.gsub! " ", ""

    doc = Nokogiri::XML(Net::HTTP.get(URI(this_uri)))
    all_artist_events = doc.xpath("//ArtistInfo//Events/Event")  

    all_artist_events.each do |ne|
      if Event.where(EventID: ne.attribute('EventID').to_s).count < 1
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
        event.play_date = Date.parse(ne.attribute('PlayDate').to_s.gsub(/, */, '-'))
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
        if event.play_date == compare.play_date && event.Region == compare.Region
          count += 1
        end
      end
        
      if count > 1
        coralation = {:date => event.play_date.to_date, :region_id => event.city_id, :region => event.Region}
        corelated_events << coralation unless corelated_events.include?(coralation)
      end
    end
    
    return corelated_events
  end
end