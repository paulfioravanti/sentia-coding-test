class Location < ApplicationRecord
  include PGEnum(
    name: [
      "Alderaan",
      "Chandrila",
      "Cloud City",
      "Corellia",
      "Death Star",
      "Haruun Kal",
      "Jakku",
      "Kamino",
      "Kashyyk",
      "Naboo",
      "Stewjon",
      "Tatooine",
      "Yoda's Hut"
    ]
  )
  has_many :residences
  has_many :people, through: :residences
end
