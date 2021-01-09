class Person < ApplicationRecord
  DEFAULT_SORT_COLUMN = "first_name".freeze
  SEARCH_QUERY =
    "prefix ILIKE :search "\
    "OR first_name ILIKE :search "\
    "OR last_name ILIKE :search "\
    "OR suffix ILIKE :search "\
    "OR species::text ILIKE :search "\
    "OR gender::text ILIKE :search "\
    "OR weapon::text ILIKE :search "\
    "OR vehicle::text ILIKE :search".freeze
  private_constant :SEARCH_QUERY

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

  def self.search(search)
    if search
      where(SEARCH_QUERY, search: "%#{search}%")
    else
      all
    end
  end

  def self.sorted_order(sort_param, sort_direction)
    order("#{sort_column(sort_param)}": sort_direction)
  end

  def self.sort_column(sort_param)
    column_names.include?(sort_param) ? sort_param : DEFAULT_SORT_COLUMN
  end
end
