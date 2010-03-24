class LocationsCriteria < ActiveRecord::Base
  belongs_to :criteria
  belongs_to :location
  
  has_many :location_criteria_ratings do
    def get_by_user_criteria(user_id, criteria_id)
      all(:conditions => ["user_id = ? AND locations_criteria_id = ?", user_id, criteria_id])
    end
  end
  
  
end
