class EventTypesController < ApplicationController
  # GET /event_types
  # GET /event_types.xml
  def index
    @event_types = EventType.all(:order => 'name')

    respond_to do |format|
      format.html
      format.xml  { render :xml => @event_types }
    end
  end

  # GET /event_types/1
  # GET /event_types/1.xml
  def show
    @event_type = EventType.find(params[:id])
    @event_date = params[:date] || Time.now().strftime("%F")
    @events = Event.type(params[:id]).on_date
    #precaution...
    if @events.size == 0
      @events = Event.type(params[:id])
      @events_title = "listing all " + @event_type.name.pluralize
    else
      @events_title = "tonights " + @event_type.name.pluralize
    end
    @filename = "/event_types/"+ @event_type.id.to_s + ".xml"
    respond_to do |format|
      format.html { render "events/index"}
      format.xml {render :action => 'event_types_location.xml.builder'}
    end
  end

  # GET /event_types/new
  # GET /event_types/new.xml
  def new
    @event_type = EventType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event_type }
    end
  end

  # GET /event_types/1/edit
  def edit
    @event_type = EventType.find(params[:id])
  end

  # POST /event_types
  # POST /event_types.xml
  def create
    @event_type = EventType.new(params[:event_type])

    respond_to do |format|
      if @event_type.save
        flash[:notice] = 'EventType was successfully created.'
        format.html { redirect_to(:controller => 'event_types') }
        format.xml  { render :xml => @event_type, :status => :created, :location => @event_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /event_types/1
  # PUT /event_types/1.xml
  def update
    @event_type = EventType.find(params[:id])

    respond_to do |format|
      if @event_type.update_attributes(params[:event_type])
        flash[:notice] = 'EventType was successfully updated.'
         format.html { redirect_to(:controller => 'event_types') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /event_types/1
  # DELETE /event_types/1.xml
  def destroy
    @event_type = EventType.find(params[:id])
    @event_type.destroy

    respond_to do |format|
      format.html { redirect_to(event_types_url) }
      format.xml  { head :ok }
    end
  end
end
