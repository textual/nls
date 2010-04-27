class EventDate < ActiveRecord::Base
  
  ajaxful_rateable :allow_update => true, :dimensions => [:overall], :cache_column => :rating
  
  belongs_to :event
  
  has_many :event_details, :as => :info
  accepts_nested_attributes_for :event_details, :allow_destroy => true
      
end
