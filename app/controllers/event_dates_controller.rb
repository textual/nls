class EventDatesController < ApplicationController
  def show
    @event_date = EventDate.find(params[:id])
  end

  def edit
    @event_date = EventDate.find(params[:id])
  end

  def update
    @event_date = EventDate.find(params[:id])
    
    params[:event_date][:from] = Time.parse(params[:event_date][:"from(5i)"])
    params[:event_date].delete(:"from(5i)")
    params[:event_date][:to] = Time.parse(params[:event_date][:"to(5i)"])
    params[:event_date].delete(:"to(5i)")
    
    if @event_date.update_attributes(params[:event_date])
      flash[:notice] = "update of event date successful"
      redirect_to event_url(@event_date.event)
    else
      render :action => "edit"
    end
  end

  def rate
    @event_date = EventDate.find(params[:id])
    @event_date.rate(params[:stars], current_user)
    render :update do |page|
      page_id = @event_date.wrapper_dom_id(params)
      page_id.slice!(0)
      
      puts 'page_id = ' + page_id
      puts 'params = ' + params.to_s
      page.replace_html page_id, ratings_for(@event_date, params.merge(:wrap => false))
      page.visual_effect :highlight, page_id
    end
          
  end
end
