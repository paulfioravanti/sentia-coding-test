class Person < ApplicationRecord
  upsert_keys [:first_name, :species, :gender]
  include PGEnum(
    species: [
      "Astromech Droid",
      "Gungan",
      "Human",
      "Hutt",
      "Protocol Droid",
      "Unknown",
      "Wookie"
    ],
    gender: ["Male", "Female", "Other"],
    weapon: [
      "Blaster",
      "Blaster Pistol",
      "Bowcaster",
      "Energy Ball",
      "Lightsaber"
    ],
    vehicle: [
      "Gungan Bongo Submarine",
      "Jabba's Sale Barge",
      "Jedi Starfighter",
      "Millennium Falcon",
      "Naboo N-1 Starfighter",
      "Rey's Speeder",
      "Slave 1",
      "Tiefighter",
      "X-wing Starfighter"
    ]
  )

  has_many :loyalties
  has_many :affiliations, through: :loyalties
  has_many :residences
  has_many :locations, through: :residences

  def name_parts
    [prefix, first_name, last_name, suffix]
  end
end
