require 'spec_helper'

describe TripArea do
    let(:user) { FactoryGirl.create(:user) }
    before do
        @trip_area = TripArea.new(
            name:           "Nowhere",
            description:    "A trip to Now Where. You must go there.",
            center_point:   "POINT(-96.0 35.0)",
            zoom_level:     12,
            user_id:        user.id
        )
    end

    subject { @trip_area }

    it { should respond_to(:name) }
    it { should respond_to(:user_id) }
    it { should respond_to(:user) }
    its(:user) { should eq user }

    it { should be_valid }

    describe "when user_id is not present" do
        before { @trip_area.user_id = nil }
        it { should_not be_valid }
    end
end
