include Geokit::Geocoders
require 'flickr_fu'

class LocationsController < ApplicationController
  
  before_filter :login_required, :only => [:create, :edit, :update, :new]
  before_filter :is_authorized, :only => [:destroy]
  
  # GET /locations
  # GET /locations.xml
  def index
    @locations = Location.all(:order => "created_at DESC")
    @cities = Location.find_by_sql("SELECT id, city, count(city) AS count FROM locations GROUP BY city ORDER BY count DESC" )
    
    @filename = "/locations.xml"
    
    respond_to do |format|
      format.html 
      format.xml {render :action => 'locations.xml.builder'}
    end
  end
  
  def city
    @locations = Location.all(:conditions => ["city = ?", params[:id]])
    @cities = Location.find_by_sql("SELECT id, city, count(city) AS count FROM locations GROUP BY city ORDER BY count DESC" )
    
    @filename =  "/locations/city/" + params[:id] + ".xml"
    
    respond_to do |format|
      format.html {render :action => 'index'}
      format.xml {render :action => 'locations.xml.builder'}
    end
  end
  
  # GET /locations/1
  # GET /locations/1.xml
  def show
    @location = Location.find(params[:id])
    flickr = Flickr.new('flickr.yml')
    @photos = flickr.photos.search(:lat => @location.lat, :lon => @location.lng, :per_page => 4, :radius => 10)
    puts "found #{@photos.size} photo(s)"
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  {render :action => 'location.xml.builder', :layout => false}
    end
  end

  # GET /locations/new
  # GET /locations/new.xml
  def new
    @location = Location.new
       
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @location }
    end
  end

  # GET /locations/1/edit
  def edit
    @location = Location.find(params[:id])
  end
  
  # GET /locations/1/edit
  def profile
    @location = Location.find(params[:id])
  end

  # POST /locations
  # POST /locations.xml
  def create
    #@location = Location.new(params[:location])
    #@name = params[:name]
    #@address = params[:full_address]
    #if params[:full_address] == "" redirect_to(locations_url)
    @render_action = "new"
    @location = Location.new(params[:location])
    @location.user = current_user
    #@location.full_address = @address
    if @location.full_address != ""    
      validate_location
    else
      render 'new'
    end
    
  end

  # PUT /locations/1
  # PUT /locations/1.xml
  def update
    @render_action = "edit"
    @location = Location.find(params[:id])
    @location.update_attributes(params[:location])
    #@loc = Location.geocode(@location.full_address)
    if @location.save
      validate_location
    else
      render 'edit'
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.xml
  def destroy
    if authorized?
      flash[:notice] = 'Location was successfully destroyed.'
      @location = Location.find(params[:id])
      @location.destroy
    else
      flash[:error] = 'You are not authorized to do delete locations.'
    end
    
    respond_to do |format|
      format.html { redirect_to(locations_url) }
      format.xml  { head :ok }
    end
  end
  
  # PRIVATE
  
  def is_authorized
    false
  end
  def validate_location
    @loc = Location.geocode(@location.full_address)
    
    if @loc.success
      if @loc.all.size == 1
        # if zip and street are present
        # or if precision = "address"
        if @loc.precision == "address"
          #' things are relatively normal here'
          respond_to do |format|
            @location.full_address = @loc.full_address
            if @location.save
              flash[:notice] = 'Location update was sucessful.'
              format.html { redirect_to(@location) }
              format.xml  { render :xml => @location, :status => :created, :location => @location }
            else
              format.html { render :action => "new" }
              format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
            end
          end
          
        else
          flash[:error] = "Address not a specific location."
          render :action => @render_action
        end
      else
        render :action => "verify_multiple"
      end
    else
      render :action => "verify_geokit"
    end
  end
  
end
