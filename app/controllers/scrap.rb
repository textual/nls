if @loc.success
  if @loc.all.count == 1
    # if zip and street are present
    # or if precision = "address"
    if @loc.precision == "address"
      # save to db
      #@new_loc = Location.new
      #@new_loc.name = @name
      #@new_loc.street_address = @loc.street_address
      #@new_loc.city = @loc.city
      #@new_loc.state = @loc.state
      #@new_loc.zip = @loc.zip
      #@new_loc.country_code = @loc.country_code
      #@new_loc.province = @loc.province
      #@new_loc.lat = @loc.lat
      #@new_loc.lng = @loc.lng
      #@new_loc.full_address = @loc.full_address
      #if @new_loc.save
      
    else
      flash[:alert] = "need more accurate address"
      render :action => "edit"
    end
  else
    # show multiple address page
    flash[:alert] = "choose valid address"
    render :action => 'verify_multiple'
  end
else
  # show entry form
  flash[:notice] = "showing entry form"
  render :action => "verify_geokit"
end