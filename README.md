# canoetrek

  This app is meant to be used as an organizational tool for outdoor trips such as canoeing, backpacking, etc. The premise is similar to Twitter in that a trip organizer defines the route of a canoe trip, hiking trip, etc by interacting with the online map and text interface. These trip details are posted and read by followers of this leader. Followers can choose to participate in the trip and then become participants. Followers have accesss to most details of the trip that includes trip reports, photos, and map locations of camping sites and travel routes. Trip participants are allowed to post details like comments and photos. The trip leader can post almost anything, including the trip report.

This is based on mhartl's tutorial. I originally did this as a learning excercise for ROR sometime in 2013. Then I modifed the data model and code to conform to my application premise.


== Credits
The tutorial that I followed is:
  http://ruby.railstutorial.org.
  https://github.com/railstutorial/sample_app_2nd_ed

This appears to have been updated and is now found at:
  https://www.railstutorial.org/book)


I also relied upon Daniel Azuma's blog on developing geospatial applications with ROR:
  http://daniel-azuma.com/articles/georails/


== Database Configuration Notes

## First, create user olapp. THen set the search _path so that users see the postgis schema:
##       psql --dbname=template1 --username=postgres
##           create role olapp with password 'olapp' login;
##
##       psql --dbname=oltst_development --username=olapp --command=
##           alter database oltst_development set search_path='$user','public','postgis';
##           Note, need to exit psql, then re-enter psql to see change.


== Data Model


== Routes

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

== More Routing Notes
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


== Trip Model

rails generate model Trip name:string description:string center:point zoom:integer

Generate trip object in rails console:
    t4 = Trip.create(:name => 't4',:description=>'Test trip four',:center=>"POINT(-95.06 39)",:zoom=>5)
    t4 = Trip.create(name: 't4',description: 'Test trip four',center: "POINT(-95.06 39)",zoom: 5)


== Notes by Others:

Routes Explained from: http://stackoverflow.com/questions/7053754/ruby-on-rails-routes

Resource pointed out in previous answers is awesome and that is where I got started. I still refer that in case I am stuck somewhere. One thing I find missing in the recourse is that it doesn't include the explanation of reading the routes table i.e. output of command rake routes and it takes time to fit the pieces together. Although if you read through the whole guide patiently, you can fit the pieces together.

On my system 'rake routes' gives the following output (excerpt relevant to resources :messages)

    messages GET    /messages(.:format)            {:action=>"index", :controller=>"messages"}
             POST   /messages(.:format)            {:action=>"create", :controller=>"messages"}
 new_message GET    /messages/new(.:format)        {:action=>"new", :controller=>"messages"}
edit_message GET    /messages/:id/edit(.:format)   {:action=>"edit", :controller=>"messages"}
     message GET    /messages/:id(.:format)        {:action=>"show", :controller=>"messages"}
             PUT    /messages/:id(.:format)        {:action=>"update", :controller=>"messages"}
             DELETE /messages/:id(.:format)        {:action=>"destroy", :controller=>"messages"}

All the columns in this table give very important information:

    Route Name(1st Column): This gives the name of the route, to which you can append "_url" or "_path" to derive the helper name for the route. For example, first one is the "messages", so you can use messages_path and messages_url in your views and controllers as a helper method. Looking at the table you can tell messages_path will generate a path of form "/messages(.:format)". Similarly, other route names generated are "new_message", "edit_message" and "message". You can also control the naming of routes.
    HTTP Verb(2nd Column): This gives the information about the http verb which this route will respond to. If it is not present, then it means this route will respond to all http verbs. Generally browsers only support, "GET" and "POST" verbs. Rails simulate "PUT" and "DELETE" by passing a parameter "_method" with verb name as value to simulate "PUT" and "DELETE". Links by default result in a "GET" verb and form submissions in "POST". In conjunction with the first column, if you use messages_path with http "GET" it would match first route and if you use it with "POST" it will match second route. This is very important to note, same url with different http verbs can map to different routes.
    URL Pattern(3rd Column): Its like a limited featured regular expression with syntax of its own. ":id" behaves like (.+) and captures the match in parameter "id", so that you can do something like params[:id] and get the captured string. Braces () represent that this parameter is optional. You can also pass these parameters in helpers to generate the corresponding route. For example if you used message_path(:id => 123) is will generate the output "/messages/123".
    Where this routes(4th Column): This column generally tells the controller and the corresponding action which will handle requests matching this route. There can be additional information here like constraints if you defined any.

So if "localhost:3000/magazines" is the page you want, you should check the routes table with url pattern as "/magazines(.:format)" and disect it yourself to find out what you need. I would recommend you read the whole guide from top to bottom if you are just starting rails.

(This might be just an overkill to write all this here, but I faced many problems due to this info not being available in a consolidated manner. Always wanted to write it out and finally did. I wish it was available on http://edgeguides.rubyonrails.org/routing.html in a separate section.)
share|improve this answer

edited May 8 at 3:51
Jon
375

answered Aug 13 '11 at 23:46
rubish
5,94011331
