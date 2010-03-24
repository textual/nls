class LocationCriteriaRating < ActiveRecord::Base
  belongs_to :locations_criteria
  has_many :locations, :through => :locations_criterias
  belongs_to :user
  
  
end
