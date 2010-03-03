class Location < ActiveRecord::Base
  
  acts_as_mappable #:auto_geocode=>{:field=>:full_address, :error_message=>'Could not geocode address'}
  belongs_to :user
  
  validates_presence_of :name, :full_address
  validates_uniqueness_of :full_address
  
  validate :geocode_address


  private

  def geocode_address
    geo=Geokit::Geocoders::MultiGeocoder.geocode(self.full_address)
    
    if geo.success
      if geo.all.size == 1
        self.full_address = geo.full_address
        self.street_address, self.city, self.state, self.zip = geo.street_address, geo.city, geo.state, geo.zip
        self.country_code, self.province = geo.country_code, geo.province
        self.lat, self.lng = geo.lat,geo.lng
      else
        errors.add(:full_address, "found multiple results")
      end
    else
      errors.add(:full_address, "Could not Geocode address")
    end
  end

end 
