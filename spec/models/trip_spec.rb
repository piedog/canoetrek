require 'spec_helper'

describe Trip do
    let(:user) { FactoryGirl.create(:user) }
#   before do
#       #not really right
#       @trip = Trip.new(name: "trip01",description: "This is trip number one", center: "POINT(-91.05 39.44)",zoom: 7, user_id: user.id)
#   end

    before { 
        @trip = Trip.new(name: "trip01",description: "This is trip number one", center: "POINT(-91.05 39.44)",zoom: 7, user_id: user.id)
    }

    subject { @trip }

    it { should respond_to (:name) }
    it { should respond_to (:description) }
    it { should respond_to (:center) }
    it { should respond_to (:zoom) }
    it { should respond_to (:user_id) }

    it { should be_valid }

    describe "when user_id is not present" do
        before { @trip.user_id = nil }
        it { should_not be_valid }
    end


    describe "with blank name" do
        before { @trip.name = " " }
        it { should_not be_valid }
    end

    describe "with name that is too long" do
        before { @trip.name = "a" * 33 }
        it { should_not be_valid }
    end

    describe "with non-numeric zoom value" do
        before { @trip.zoom = "zyx" }
        it { should_not be_valid }
    end
    

    describe "with missing center location value" do
        before { @trip.center = " " }
        it { should_not be_valid }
    end

end
