class ReviewsController < ApplicationController

  def index
      @location = Location.find(params[:location_id])
      @reviews = @location.reviews
    end

    def show
      @location = Location.find(params[:location_id])
      @review = @location.reviews.find(params[:id])
    end

    def new
      @location = Location.find(params[:location_id])
      @review = @location.reviews.build
    end

    def create
      @location = Location.find(params[:location_id])
      @review = @location.reviews.build(params[:review])
      @review.user = current_user
      if @review.save
        flash[:notice] = 'Review was successfully created.'
        # update locations over all average
        @location.rating = @location.reviews.average('rating')
        @location.save
      else
        flash[:error] = 'you must have a rating and a comment.'
      end
      respond_to do |format|
        format.html {redirect_to location_url(@location)}
        format.js
      end
    end

    def edit
      @location = Location.find(params[:location_id])
      @review = @location.reviews.find(params[:id])
    end

    def update
      @location = Location.find(params[:location_id])
      @review = Review.find(params[:id])
      if @review.update_attributes(params[:review])
        redirect_to location_review_url(@location, @review)
      else
        render :action => "edit"
      end
    end

    def destroy
      @location = Location.find(params[:location_id])
      @review = Review.find(params[:id])
      @review.destroy

      respond_to do |format|
        format.html { redirect_to location_reviews_path(@location) }
        format.xml  { head :ok }
      end
    end

end
