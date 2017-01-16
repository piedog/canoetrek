# canoetrek

  This app is meant to be used as an organizational tool for outdoor trips such as canoeing, backpacking, etc. The premise is similar to Twitter in that a trip organizer defines the route of a canoe trip, hiking trip, etc by interacting with the online map and text interface. These trip details are posted and read by followers of this leader. Followers can choose to participate in the trip and then become participants. Followers have accesss to most details of the trip that includes trip reports, photos, and map locations of camping sites and travel routes. Trip participants are allowed to post details like comments and photos. The trip leader can post almost anything, including the trip report.

This is based on mhartl's tutorial. I originally did this as a learning excercise for ROR sometime in 2013. Then I modifed the data model and code to conform to my application premise.


## Credits
The tutorial that I followed is:
  http://ruby.railstutorial.org.
  https://github.com/railstutorial/sample_app_2nd_ed

This appears to have been updated and is now found at:
  https://www.railstutorial.org/book)


I also relied upon Daniel Azuma's blog on developing geospatial applications with ROR:
  http://daniel-azuma.com/articles/georails/


## Database Configuration Notes

 First, create user olapp. THen set the search _path so that users see the postgis schema:
       psql --dbname=template1 --username=postgres
           create role olapp with password 'olapp' login;

       psql --dbname=oltst_development --username=olapp --command=
           alter database oltst_development set search_path='$user','public','postgis';
           Note, need to exit psql, then re-enter psql to see change.

## External Dependencies
* PostgreSQL
* PostGIS spatial extension must be configured with PostgreSQL
* Geoserver is required to serve up location information to the application
* The application also consumes base map information 

## Data Model

### Trip Model

rails generate model Trip name:string description:string center:point zoom:integer

Generate trip object in rails console:
    t4 = Trip.create(:name => 't4',:description=>'Test trip four',:center=>"POINT(-95.06 39)",:zoom=>5)
    t4 = Trip.create(name: 't4',description: 'Test trip four',center: "POINT(-95.06 39)",zoom: 5)

## Routes

    map.resources :users do |user|
        users.resources :trips
    end


    users_url                   /users
    user_url(1)                 /users/1
    user_trip_url(1)            /users/1/trips

    trip_url(2)                 /trips/2
    trip_photos_url(2)          /trips/2/photos

    photo_url(3)                /photos/3
    photo_comments_url          /photos/3/comments

    comment_url(4)              /comments/4

## More Routing Notes
=============================================
Home Page of Signed-In User

------------------- Column One ---------------

MyTrips /users/x/trips
    N = @user.trips.count

    * Trip-1        /users/x/trips/y
      Description
      Participants  /trips/y/participants

    * Trip-2        /users/x/trips/z
      Description
      Participants  /trips/z/participants

    More trips I lead... /users/x/trips

------------------- Column One ---------------

Trip I have joined    /users/x/enrollments
    N = @user.enrollments.count   ???

    * Trip-A        /users/xxx/trips/aaa
      Description
      Trip Leader   /users/xxx

    * Trip-B        /users/yyy/trips/bbb
      Description
      Trip Leader   /users/yyy

    More trips I have joined... /users/x/enrollments

=============================================
 enrollments_user GET    /users/:id/enrollments(.:format)    users#enrollments
      enrollments POST   /enrollments(.:format)              enrollments#create
       enrollment DELETE /enrollments/:id(.:format)          enrollments#destroy

participants_trip GET    /trips/:id/participants(.:format)   trips#participants

       user_trips GET    /users/:user_id/trips(.:format)     trips#index
                  POST   /users/:user_id/trips(.:format)     trips#create
        user_trip DELETE /users/:user_id/trips/:id(.:format) trips#destroy
            users GET    /users(.:format)                    users#index
                  POST   /users(.:format)                    users#create
         new_user GET    /users/new(.:format)                users#new
        edit_user GET    /users/:id/edit(.:format)           users#edit
             user GET    /users/:id(.:format)                users#show
                  PUT    /users/:id(.:format)                users#update
                  DELETE /users/:id(.:format)                users#destroy
            trips POST   /trips(.:format)                    trips#create
             trip DELETE /trips/:id(.:format)                trips#destroy

