class Trip < ActiveRecord::Base
    attr_accessor :longitude, :latitude
    attr_accessible :longitude, :latitude, :description, :name, :zoom, :user_id

    belongs_to :user

    validates :longitude,presence: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
    validates :latitude, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
    validates :user_id, presence: true
    validates :name, presence: true, length: { maximum: 32 }
    validates :zoom, allow_nil: false, numericality: { in: 1..12 }

    before_save :update_center

    default_scope -> { order('created_at DESC') }


    def self.from_trips_enrolled_by(user)
        opentrip_ids = "SELECT opentrip_id from enrollments where participant_id = :user_id"
        where("id IN (#{opentrip_ids})", user_id: user.id)
    end





#   private
    def update_center
        if longitude.present? || latitude.present?
            long = longitude || self.center.longitude
            lat = latitude || self.center.latitude
            self.center = RGeo::Geographic.spherical_factory(srid: 4326).point(long,lat)
        end
    end

end
