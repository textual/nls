class Review < ActiveRecord::Base
  belongs_to :location
  belongs_to :user
  
  validates_presence_of     :rating, :comment
  
end
