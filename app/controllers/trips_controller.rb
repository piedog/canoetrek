class TripsController < ApplicationController

    require 'rgeo'
  # before_action :signed_in_user


    def new
        @user = User.find(params[:user_id])
        @trip = Trip.new
    end

    def create
     #  gfactory = RGeo::Geographic.spherical_factory
     #  loc = gfactory.point(long,lat)
        @trip = current_user.trips.build(params[:trip])
        if @trip.save
            flash[:success] = "Trip created!"
            redirect_to root_url
        else
            @tripfeed_items = []
            render 'static_pages/home'
        end
    end

    def destroy
        @trip.destroy
        redirect_to root_url
    end

    def index
        @user = User.find(params[:user_id])
        @trips = @user.trips
        ## @trips = @user.trips.paginate(page: params[:page])
    end

    def alltrips
      # @trips = Trip.find(:all, joins: :user)
        @trips = Trip.paginate( joins: :user, page: params[:page], per_page: 5)
    end


    def show
        @user = User.find(params[:user_id])
        @trip = Trip.find(params[:id])
    end

end
