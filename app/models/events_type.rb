class EventsType < ActiveRecord::Base
  belongs_to :event
  belongs_to :event_type
end
