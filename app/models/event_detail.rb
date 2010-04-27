class EventDetail < ActiveRecord::Base
  belongs_to :info, :polymorphic => true
end