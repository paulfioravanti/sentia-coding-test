class Affiliation < ApplicationRecord
  has_many :loyalties
  has_many :people, through: :loyalties
end
