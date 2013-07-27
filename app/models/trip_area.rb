class TripArea < ActiveRecord::Base
    belongs_to :user
    attr_accessible :center_point, :description, :name, :user_id, :zoom_level
    set_rgeo_factory_for_column(:center_point, RGeo::Geographic.spherical_factory(:srid => 4326))
    validates :user_id, presence: true
end
