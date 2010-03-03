xml.locations(:source => 'nls'){
  xml.data{
    xml.longitude(@location.lng)
    xml.latitude(@location.lat)
    xml.title(@location.name)
    xml.description(@location.street_address + " " + @location.city)
  }
}