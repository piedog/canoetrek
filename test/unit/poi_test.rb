# == Schema Information
#
# Table name: pois
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  latitude   :float
#  longitude  :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class PoiTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
