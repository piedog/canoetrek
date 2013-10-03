# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
    attr_accessible :email, :name, :password, :password_confirmation
    has_secure_password
    has_many :microposts, dependent: :destroy
    has_many :relationships, foreign_key: "follower_id", dependent: :destroy
    has_many :followed_users, through: :relationships, source: :followed
    has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
    has_many :followers, through: :reverse_relationships, source: :follower

    has_many :trips, dependent: :destroy

    has_many :enrollments, foreign_key: "participant_id", dependent: :destroy
    has_many :reverse_enrollments, foreign_key: "opentrip_id", class_name: "Enrollment", dependent: :destroy
    has_many :participants, through: :reverse_enrollments, source: :participant

    before_save { |user| user.email = email.downcase }
    before_save :create_remember_token

    validates :name, presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

    validates :password, presence: true, length: { minimum: 6 }
    validates :password_confirmation, presence: true


    def feed
        Micropost.from_users_followed_by(self)
    end

    ##  all trips that user is participating in (all trips that this user is enrolled in)
    def tripfeed
        Trip.from_trips_enrolled_by(self)
    end

    def following?(other_user)
        relationships.find_by_followed_id(other_user.id)
    end

    def follow!(other_user)
        relationships.create!(followed_id: other_user.id)
    end

    def unfollow!(other_user)
        relationships.find_by_followed_id(other_user.id).destroy
    end

    def enroll!(trip)
        enrollments.create!(opentrip_id: trip.id)
    end

    def unenroll!(trip)
        enrollments.find_by_opentrip_id(trip.id).destroy
    end

    def enrolled?(trip)
        enrollments.find_by_opentrip_id(trip.id)
    end


    private

        def create_remember_token
            self.remember_token = SecureRandom.urlsafe_base64
        end
end
