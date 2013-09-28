class Enrollment < ActiveRecord::Base
    attr_accessible :opentrip_id
    belongs_to :participant, class_name: "User"
    belongs_to :opentrip, class_name: "Trip"

    validates :participant_id, presence: true
    validates :opentrip_id,    presence: true
end
