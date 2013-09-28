namespace :db do
    desc "Fill database with sample data"
    task populate: :environment do
        make_users
        make_microposts
        make_relationships
        make_trips
        make_enrollments
    end
end


def make_users

    admin = User.create!(name: "Example User",
                email: "example@railstutorial.org",
                password: "foobar",
                password_confirmation: "foobar")
    admin.toggle!(:admin)

    99.times do |n|
        name = Faker::Name.name
        email = "example-#{n+1}@railstutorial.org"
        password = "password"
        User.create!(name: name,
                    email: email,
                    password: password,
                    password_confirmation: password)
    end
end


def make_microposts
    users = User.all(limit: 6)
    50.times do
        content = Faker::Lorem.sentence(5)
        users.each { |user| user.microposts.create!(content: content) }
    end
end


def make_relationships
    users = User.all
    user = users.first
    followed_users = users[2..50]
    followers      = users[3..40]
    followed_users.each { |followed| user.follow!(followed) }
    followers.each      { |follower| follower.follow!(user) }
end


def make_trips
    ## Make 5 trips for each user
    users = User.all(limit: 6)
    trip_num = 0
    2.times do |n|
        trip_num = trip_num+1
        name = "trip-#{trip_num}"
        description = Faker::Lorem.sentence(5)
        longitude = -90.5
        latitude = 45.5
        zoom = 8
        users.each { |user|
            user.trips.create!(name: "#{name}-#{user.id}", description: description, longitude: longitude, latitude: latitude , zoom: zoom)
        }
    end
end


def make_enrollments
    users = User.all
    participants = users[11..50]

    trips = Trip.all
    opentrips = trips[1..6]


    6.times do |n|
        participants.each      { |participant| participant.enroll!(opentrips[n]) }
    end


end
