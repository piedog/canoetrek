class StaticPagesController < ApplicationController
    def home
        if signed_in?
            @trip = current_user.trips.build
            @tripfeed_items = current_user.tripfeed.paginate(page: params[:page])
        end
    end
end
