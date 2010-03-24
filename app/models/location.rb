class Location < ActiveRecord::Base
  
  acts_as_mappable #:auto_geocode=>{:field=>:full_address, :error_message=>'Could not geocode address'}
  belongs_to :user
  has_many :reviews, :order => "created_at DESC"
  has_many :recent_reviews, 
            :class_name => "Review",
            :order => "created_at DESC",
            :limit => 4
  has_many :locations_criterias do
    def top_level
      all(:joins => :criteria, :conditions => "criterias.parent_id is null", :order => "name")
    end
    
    def children(id)
      all(:joins => :criteria, :conditions => ["criterias.parent_id = ?", id], :order => "name")
    end
  end
  
  has_many :criterias, :through => :locations_criterias do
    def parents
      all(:conditions => "parent_id is null")
    end
    def children(id)
      all(:conditions => ["parent_id = ?", id])
    end
  end
  
  has_many :location_criteria_ratings, :through => :location_criterias
  
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
