class EventsController < ApplicationController
  
  before_filter :show_map, :only => [:index, :show]
  
  # GET /events
  # GET /events.xml
  def index
    #puts "params[:date] = " + params[:date] if params[:date]
    @event_date = params[:date] || Time.now().strftime("%F")
    @events_title = (@event_date == Time.now().strftime("%F") ) ? "Tonight : " : ""
    @events_title += @event_date.to_date.strftime("%A %B #{@event_date.to_date.day.ordinalize}"); 
    
    @events = Event.on_date(@event_date).find_within(500, :origin => session[:geo_location], :order => "distance")
    
    @map = GMap.new("map_div")
    @map.control_init(:large_map => true, :map_type => true)
    sorted_latitudes = [] 
    sorted_longitudes = []
    
    @events.each do |event|
      @map.overlay_init(GMarker.new([event.location.lat,event.location.lng],:title => event.location.name, :info_window => event.location.name + "<br/>" + event.name))
      sorted_latitudes << event.location.lat.to_s
      sorted_longitudes << event.location.lng.to_s
    end    
    
    sorted_latitudes.sort
    sorted_longitudes.sort
    
    @map.center_zoom_on_bounds_init([
      [sorted_latitudes.first, sorted_longitudes.first], 
      [sorted_latitudes.last, sorted_longitudes.last]])
  
  
    respond_to do |format|
      format.html # show_all.html.erb
      format.xml {render :action => 'events_location.xml.builder'}
    end
    
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])
    @location = @event.location
    get_flickr_photos(@location)
    
    @map = GMap.new("map_div_small")
    @map.control_init(:small_zoom => true)
    @map.center_zoom_init([@location.lat,@location.lng],12)
    
    @map.overlay_init(GMarker.new([@location.lat,@location.lng],:title => @location.name, :max_width => 100, :info_window => "<a href='http://maps.google.com/maps?daddr=" + @location.full_address + "' target='blank'>get directions</a>"))
    
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  {render :action => '../locations/location.xml.builder', :layout => false}
    end
  end
  


  # GET /events/new
  # GET /events/new.xml
  def new
    @location = Location.find(params[:location_id])
    @event = @location.events.build
    @event.event_details.build
    @event_types = EventType.all(:order => 'name')

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
    @location = @event.location
    @event_types = EventType.all(:order => 'name')
    
  end

  # POST /events
  # POST /events.xml
  def create
    @location = Location.find(params[:location_id])
    @event_types = EventType.all(:order => 'name') # strictly for display of error
    
    # sanitize and all that
    #params[:event][:event_details_attributes][:"0"][:desc] = format_content(params[:event][:event_details_attributes][:"0"][:desc])
    
    # format time from plugin
    params[:event][:event_details_attributes][:"0"][:time_from] = Time.parse(params[:event_data][:"time_from(5i)"])
    params[:event_data].delete([:"time_from(5i)"])
    params[:event][:event_details_attributes][:"0"][:time_to] = Time.parse(params[:event_data][:"time_to(5i)"])
    params[:event_data].delete([:"time_to(5i)"])
    
    @event = @location.events.create(params[:event])
    @event.location = @location
    @event.event_dates.each do |ed|
      ed.destroy unless ed.day || ed.date       
    end
    
    respond_to do |format|
      if @event.save
        flash[:notice] = 'Event was successfully created.'
        format.html { redirect_to(@event) } # for realz
        #format.html { render :action => "new" } # for test
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" } # index used to add events...sorry
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def old_create
    @event_types = EventType.all(:order => 'name')
    
    days = params[:event_date][:day]
    dates = params[:event_date][:date]
    
    if days
      days.each do |d|
        event_date = EventDate.new
        event_date.event_id = @event.id
        event_date.day = d
        event_date.from = params[:event_date][:"from(5i)"]
        event_date.to = params[:event_date][:"to(5i)"]
        event_date.desc = params[:event_date][:desc]
        event_date.price_advance = params[:event_date][:price_advance]
        event_date.price_door = params[:event_date][:price_door]
        event_date.purchase_url = params[:event_date][:purchase_url]
        event_date.save
        
        puts 'day : save ' + params[:event_date][:desc] + " from " + params[:event_date][:"from(5i)"] + " to " + params[:event_date][:"to(5i)"] 
      end
    else
      dates.each do |d|
        event_date = EventDate.new
        event_date.event_id = @event.id
        event_date.date = d
        event_date.from = params[:event_date][:"from(5i)"]
        event_date.to = params[:event_date][:"to(5i)"]
        event_date.desc = params[:event_date][:desc]
        event_date.price_advance = params[:event_date][:price_advance]
        event_date.price_door = params[:event_date][:price_door]
        event_date.purchase_url = params[:event_date][:purchase_url]
        event_date.save
        
        puts 'date: save ' + params[:event_date][:desc] + " from " + params[:event_date][:"from(5i)"] + " to " + params[:event_date][:"to(5i)"] 
      end
    end
    
    
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        flash[:notice] = 'Event was successfully updated.'
        format.html { redirect_to(@event) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end
end
