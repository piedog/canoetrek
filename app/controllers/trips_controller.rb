class TripsController < ApplicationController
  # before_action :signed_in_user

    def create
    end

    def destroy
    end

    def index
        @user = User.find(params[:user_id])
        @trip_items = @user.trip_areas
    end
end
