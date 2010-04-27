class EventType < ActiveRecord::Base
  has_many :events_types
  has_many :events, :through => :events_types
end
