# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'flickr_fu'

class ApplicationController < ActionController::Base
  
  include AuthenticatedSystem
  require 'linguistics'
  Linguistics::use( :en )
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
 def get_flickr_photos(location)
   flickr = Flickr.new('flickr.yml')
   @photos = flickr.photos.search(:lat => location.lat, :lon => location.lng, :per_page => 4, :radius => 10, :media => 'photos')
 end
 
 
end
