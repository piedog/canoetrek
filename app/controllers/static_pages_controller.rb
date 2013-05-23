class StaticPagesController < ApplicationController
    def map
        gon.mapoptions = {
            msg: 'hello world',
            centerx: -10545985,
            centery:   4323684,
            zoom:      9,
            mapdiv:  'map-container'
        }
    end

    def home
        if signed_in?
            @micropost = current_user.microposts.build
            @feed_items = current_user.feed.paginate(page: params[:page])
        end
    end
end
