xml.instruct!
xml.data(:type => "array", :event_date => @event_date ){
  @events.each do |event| 
    location = event.location
      xml.datum{
        xml.id(location.id)
        xml.title(location.name)
        xml.description(location.street_address + "<br/>" + location.city + " " + location.state + " " + location.zip + "<br/>")
        xml.latitude(location.lat, 'type' => 'decimal')
        xml.longitude(location.lng, 'type' => 'decimal')
      }
    
  end
}