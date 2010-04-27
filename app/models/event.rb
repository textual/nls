class Event < ActiveRecord::Base
  belongs_to :location
  
  has_many :event_details, :as => :info, :dependent => :destroy
  accepts_nested_attributes_for :event_details, :allow_destroy => true
  
  has_many :events_types, :dependent => :destroy
  accepts_nested_attributes_for :events_types, :allow_destroy => true
  has_many :event_types, :through => :events_types
 
  has_many :event_dates, :dependent => :destroy
  accepts_nested_attributes_for :event_dates, :allow_destroy => true

  named_scope :type,
              lambda { |*args|
                {:include => [:event_types],
                  :conditions => ['event_types.id = ?', (args.first || 1)]
                }
              }
              
  named_scope :on_date, 
              lambda { |use_date = Time.now().strftime("%F"), *|
                {
                  :include => :event_dates,
                  :conditions => ['event_dates.date = ? OR event_dates.day = ?', use_date, use_date.to_date.wday]
                }
              }
              
  
              
  validates_presence_of :location, :name
  
  def rating
    self.event_dates[0].rating
  end
  def self.get_locations
    Location.all :joins => :events
  end
end
