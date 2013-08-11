class Trip < ActiveRecord::Base
    attr_accessible :center, :description, :name, :zoom, :user_id
    set_rgeo_factory_for_column(:center, RGeo::Geographic.spherical_factory(:srid => 4326))

    validates :user_id, presence: true
end
