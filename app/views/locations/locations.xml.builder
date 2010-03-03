xml.instruct!
xml.data(:type => "array"){
  for location in @locations
    xml.datum{
      xml.id(location.id)
      xml.title(location.name)
      xml.description(location.street_address + "<br/>" + location.city + " " + location.state + " " + location.zip + "<br/>")
      xml.latitude(location.lat, 'type' => 'decimal')
      xml.longitude(location.lng, 'type' => 'decimal')
    }
  end
}