include Geokit::Geocoders

class LocationsController < ApplicationController
  
  before_filter :login_required, :only => [:create, :edit, :update, :destroy, :new]
  
  # GET /locations
  # GET /locations.xml
  def index
    @locations = Location.all

    respond_to do |format|
      format.html 
      format.xml {render :action => 'locations.xml.builder'}
    end
  end
  # GET /locations/1
  # GET /locations/1.xml
  def show
    @location = Location.find(params[:id])

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

  # POST /locations
  # POST /locations.xml
  def create
    #@location = Location.new(params[:location])
    #@name = params[:name]
    #@address = params[:full_address]
    #if params[:full_address] == "" redirect_to(locations_url)
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
    @location = Location.find(params[:id])
    @location.destroy

    respond_to do |format|
      format.html { redirect_to(locations_url) }
      format.xml  { head :ok }
    end
  end
  
  # PRIVATE
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
              flash[:notice] = 'Location was successfully created.'
              format.html { redirect_to(@location) }
              format.xml  { render :xml => @location, :status => :created, :location => @location }
            else
              format.html { render :action => "new" }
              format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
            end
          end
          
        else
            render :action => "verify_geokit"
        end
      else
        render :action => "verify_multiple"
      end
    else
      render :action => "verify_geokit"
    end
  end
  
end
