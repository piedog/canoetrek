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

class Poi < ActiveRecord::Base
  attr_accessible :latitude, :longitude, :name
end
