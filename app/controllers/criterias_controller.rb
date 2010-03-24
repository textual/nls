class CriteriasController < ApplicationController
  
  before_filter :login_required, :only => [:edit_location, :rate_location, :assign_location]
  before_filter :authorized?, :only => [:index, :create, :destroy]
   
  def index
    @parents = Criteria.parents #(:all, :conditions => "parent_id IS NULL", :order => 'name')
    @criteria = Criteria.new
  end
  
  # GET /criteria/1/edit
  def edit
   @criteria = Criteria.find(params[:id])
  end
  
  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @criteria = Criteria.find(params[:id])

     respond_to do |format|
       if @criteria.update_attributes(params[:criteria])
         flash[:notice] = 'criteria name was successfully updated.'
         format.html { redirect_to(:criterias) }
         format.xml  { head :ok }
       else
         format.html { render :action => "edit" }
         format.xml  { render :xml => @criteria.errors, :status => :unprocessable_entity }
       end
     end
   end
   

  def create
    @criteria = Criteria.new(params[:criteria])
    respond_to do |format|
      if @criteria.save
        flash[:notice] = 'Criteria was successfully created.'
        format.html { redirect_to(criterias_url) }
        format.xml  { render :xml => @criteria, :status => :created, :location => @criteria }
      else
        flash[:error] = 'Criteria needs a name fool.'
        format.html { render :action => "index" }
        format.xml  { render :xml => @criteria.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit_location
    @location = Location.find(params[:id])
    @parents = Criteria.parents
  end
  
  def rate_location
    @location = Location.find(params[:id])
    #@my_ratings = current_user.location_criteria_ratings.for_location(@location.id)
    puts @location
    if request.post?
      params[:rating].each do |c|
              
        if c[1] != ""
          @location_criteria = LocationsCriteria.find(c[0])
          @current_rating = @location_criteria.location_criteria_ratings.get_by_user_criteria(current_user.id, c[0]) 
          if @current_rating.size == 0
            @rating = LocationCriteriaRating.new 
          else
            @rating = @current_rating.first
          end
          
          #@rating = LocationCriteriaRating.find_or_create_by_user_id(current_user, :locations_criteria_id => c[0])
          puts 'save ' + c[0] + " as " + c[1] + " in " + @rating.to_s
          @rating.locations_criteria_id = c[0]
          @rating.rating = c[1]
          @rating.user = current_user
          @rating.save
          
          puts("save " + LocationCriteriaRating.average("rating", :conditions => "locations_criteria_id = #{c[0]}").to_s + " as average")
          @location_criteria.rating = LocationCriteriaRating.average("rating", :conditions => "locations_criteria_id = #{c[0]}")
          @location_criteria.save
          
        end
      end
      
     if params[:rating].size > 0 
        flash[:notice] = 'ratings saved.'
      else
        flash[:error] = 'NO RATINGS CLICKED'
      end
      
      respond_to do |format|
        format.html {redirect_to location_url(@location)}
        #format.js
      end
      
    end
  end
  
  def rate_create
    @location = Location.find(params[:location_id])
    respond_to do |format|
      format.html {redirect_to location_url(@location)}
      format.js
    end
  end
  
  def assign_location
    @location = Location.find(params[:id])
    #params[:location][:criteria_ids] ||= []
    if @location.update_attributes(params[:location])
      redirect_to @location
    else
      render :action => 'edit_location'
    end
  end
  
end
