class AdminController < ApplicationController
  def index
  end

  def events
     @events = Event.all(:order => "created_at DESC")
  end
  
  def users
    @users = User.all(:order => "created_at DESC")
  end
  
  def loc_search
    @search = Location.search(params[:search])
  end
  
end
