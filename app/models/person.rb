class Person < ApplicationRecord
  has_many :loyalties
  has_many :affiliations, through: :loyalties
end
