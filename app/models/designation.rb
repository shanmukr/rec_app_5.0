class Designation < ApplicationRecord
  validates_presence_of   :name
  validates_uniqueness_of :name
  auto_strip_attributes   :name, :squish => true
end
