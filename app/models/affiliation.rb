class Affiliation < ApplicationRecord
  include PGEnum(
    name: [
      "First Order",
      "Galactic Republic",
      "Gungan Grand Army",
      "Hutt Clan",
      "Jedi Order",
      "Rebel Alliance",
      "Sith",
      "The Resistance"
    ]
  )

  has_many :loyalties
  has_many :people, through: :loyalties
end
