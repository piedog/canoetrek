class TripArea < ActiveRecord::Base
    belongs_to :user
    attr_accessible :center_point, :description, :name, :user_id, :zoom_level
    default_scope -> { order('created_at DESC') }
    validates :user_id, presence: true
    validates :name, presence: true, length: { maximum: 16 }
    set_rgeo_factory_for_column(:center_point, RGeo::Geographic.spherical_factory(:srid => 4326))
end
