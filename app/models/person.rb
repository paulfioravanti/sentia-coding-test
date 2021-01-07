class Person < ApplicationRecord
  has_many :loyalties
  has_many :affiliations, through: :loyalties
  has_many :residences
  has_many :locations, through: :residences
end
