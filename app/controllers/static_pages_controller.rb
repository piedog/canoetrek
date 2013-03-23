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
  end
end
