class Trip < ActiveRecord::Base
    attr_accessible :center, :description, :name, :zoom, :user_id
    set_rgeo_factory_for_column(:center, RGeo::Geographic.spherical_factory(:srid => 4326))

    belongs_to :user
    default_scope -> { order('created_at DESC') }

    validates :user_id, presence: true
    validates :name, presence: true, length: { maximum: 32 }

    validates_numericality_of :zoom, allow_nil: false, in: 1..12, message: "a zoom level must be provided between 1 and 12"
end
