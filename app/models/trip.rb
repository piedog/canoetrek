class Trip < ActiveRecord::Base
    attr_accessible :center, :description, :name, :zoom
    set_rgeo_factory_for_column(:center, RGeo::Geographic.spherical_factory(:srid => 4326))
end
