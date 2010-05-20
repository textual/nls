# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.


class ApplicationController < ActionController::Base
  
  require 'flickr_fu'
  
  include AuthenticatedSystem
  require 'linguistics'
  Linguistics::use( :en )
  
  before_filter :set_facebook_session
  helper_method :facebook_session
  #ensure_application_is_installed_by_facebook_user
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  geocode_ip_address

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  filter_parameter_logging :fb_sig_friends
  
 def get_flickr_photos(location)
   flickr = Flickr.new('flickr.yml')
   @photos = flickr.photos.search(:lat => location.lat, :lon => location.lng, :per_page => 4, :radius => 10, :media => 'photos')
 end
 
 def show_map
   @show_map = true
 end
 
 def set_city(use_city)
   @geo = Geokit::Geocoders::MultiGeocoder.geocode(use_city)
    if @geo.success
      session[:geo_location] = @geo
    end
 end
 
 
end
