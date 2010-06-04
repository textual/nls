class Criteria < ActiveRecord::Base
  acts_as_tree :order => "name"
  
  has_many :locations_criterias
  has_many :locations, :through => :locations_criterias
  
  validates_presence_of :name
  
  #def self.parents
  #  Criteria.find(:all, :conditions => "parent_id IS NULL", :order => 'name')
  #end
  
  def self.random
    Criteria.find_by_id rand(Quote.count) + 1
  end
  
end
