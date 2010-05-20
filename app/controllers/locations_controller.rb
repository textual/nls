include Geokit::Geocoders


class LocationsController < ApplicationController
  
  before_filter :login_required, :only => [:create, :edit, :update, :new]
  before_filter :authorized?, :only => [:destroy]
  before_filter :show_map, :only => [:index, :show, :city, :search]
  
  # GET /locations
  # GET /locations.xml
  def index
    #@locations = Location.find(:all, :origin => session[:geo_location], :order => "distance").paginate
    @locations = Location.within(session[:geo_location], 100).paginate :page => params[:page]
    @map = GMap.new("map_div")
    @map.control_init(:large_map => true, :map_type => true)
    sorted_latitudes = @locations.collect(&:lat).compact.sort
    sorted_longitudes = @locations.collect(&:lng).compact.sort
    @map.center_zoom_on_bounds_init([
      [sorted_latitudes.first, sorted_longitudes.first], 
      [sorted_latitudes.last, sorted_longitudes.last]])
  
    @locations.each do |location|
      @map.overlay_init(GMarker.new([location.lat,location.lng],:title => location.name, :info_window => location.name + "<br/>" + location.full_address))
    end
    
    get_cities
      
    respond_to do |format|
      format.html 
      format.xml {render :action => 'locations.xml.builder'}
    end
  end
  
  def city
    #@locations = Location.all(:conditions => ["city = ?", params[:id]], :order => "created_at DESC").paginate
    set_city(params[:id]) if params[:id]
    redirect_to :action => 'index'
  end
  
  # GET /locations/1
  # GET /locations/1.xml
  def show    
    
    @location = Location.find(params[:id])
    
    @map = GMap.new("map_div_small")
    @map.control_init(:small_zoom => true)
    @map.center_zoom_init([@location.lat,@location.lng],12)
    
 
    @map.overlay_init(GMarker.new([@location.lat,@location.lng],:title => @location.name, :max_width => 100, :info_window => "<a href='http://maps.google.com/maps?daddr=" + @location.full_address + "' target='blank'>get directions</a>"))
    
    
    get_flickr_photos(@location)
    
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
  
  def search
    @query = params[:query]
    @city = params[:city]
    set_city(@city) if @city
    
    if @query
      #@locations = Location.within(session[:geo_location], 500).search(@query).paginate :page => params[:page]
      #@locations = Location.search(@query).criterias_name_like(@query).paginate :page => params[:page]
      @locations = Location.criterias_name_or_name_like(@query).distinct.paginate(:page => params[:page])
      
      get_cities
    
      @map = GMap.new("map_div")
      @map.control_init(:large_map => true, :map_type => true)
      #@map.center_zoom_init([session[:geo_location].lat, session[:geo_location].lng],5)
      sorted_latitudes = @locations.collect(&:lat).compact.sort
      sorted_longitudes = @locations.collect(&:lng).compact.sort
      @map.center_zoom_on_bounds_init([
        [sorted_latitudes.first, sorted_longitudes.first], 
        [sorted_latitudes.last, sorted_longitudes.last]])
    
      @locations.each do |location|
        @map.overlay_init(GMarker.new([location.lat,location.lng],:title => location.name, :info_window => location.name + "<br/>" + location.full_address))
      end
    
       respond_to do |format|
          format.html {render :action => 'index'}
          format.xml {render :action => 'locations.xml.builder'}
       end
    else
      redirect_to :action => "index"
    end
    
  end
  
  # PRIVATE
  def get_cities
    @cities = Location.find_by_sql("SELECT city, count(city) AS count FROM locations GROUP BY city ORDER BY count DESC" )
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
              format.html { redirect_to(assign_criteria_url(:id => @location.id)) }
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
