FactoryGirl.define do
  # factory :user do
  #     name        "Example User"
  #     email       "example@user.com"
  #     password    "foobar"
  #     password_confirmation  "foobar"
  # end

    factory :user do
        sequence(:name) { |n| "Person #{n}" }
        sequence(:email) { |n| "person_#{n}@example.com" }
        password "foobar"
        password_confirmation "foobar"

        factory :admin do
            admin true
        end
    end

    factory :micropost do
        content "Lorem ipsum"
        user
    end

    factory :trip_area do
        name           "Nowhere"
        description    "A trip to Now Where. You must go there."
        center_point   "POINT(-96.0 35.0)"
        zoom_level     12
        user
    end

end
