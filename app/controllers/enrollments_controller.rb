class EnrollmentsController < ApplicationController
    before_filter :signed_in_user, only: [:create, :destroy]
    before_filter :correct_user, only: :destroy


=begin
select u.id, u.name, t.id,t.name,L.name from users as u
join enrollments as e on u.id=e.participant_id
join trips as t on t.id=e.opentrip_id
join users as L on L.id=t.user_id
where u.id=13
;
select u.id, u.name, t.id,t.name,L.name from trips as t
join enrollments as e on t.id=e.opentrip_id
join users as u on e.participant_id=u.id
join users as L on t.user_id=L.id
where u.id=13
;
=end

    def index
      # @user = User.find_by_id(params[:id])
      # @enrollments = Enrollment.find_by_participant_id(params[:id])
        @trips = Trip.joins(:enrollments => {:user => params([:id]) } )

User.joins(:notifications)
    .joins("LEFT JOIN `company_users` ON `company_users`.`user_id` = `users`.`id`")
    .joins(:role_users)
    .where("notifications.id = ? AND role_users.role_id != '1' AND (company_users.company_id = ? OR users.company_id = ?)", notification.id, p.company_id, p.company_id)

Trip.joins(:enrollments)
    .joins("left join users as u on e.participant_id=u.id")
    .joins("left join users as L on t.user_id=L.id")



    end


    def create
    end


    def destroy
        @enrollment.destroy
        redirect_to root_url
    end
end
