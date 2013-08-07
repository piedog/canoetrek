require 'spec_helper'

describe Trip do
    let(:user) { FactoryGirl.create(:user) }
    before do
        #not really right
        @trip = Trip.new(name: "trip01",description: "This is trip number one", center: "POINT(-91.05 39.44)",zoom: 7, user_id: user.id)
    end


    subject { @trip }
    it { should respond_to (:name) }
    it { should respond_to (:description) }
    it { should respond_to (:center) }
    it { should respond_to (:zoom) }
    it { should respond_to (:user_id) }
end
