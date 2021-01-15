class Person < ApplicationRecord
  SORT_COLUMNS = %w(
    prefix
    first_name
    last_name
    suffix
    first_location_name
    species
    gender
    first_affiliation_name
    weapon
    vehicle
  ).freeze
  private_constant :SORT_COLUMNS
  DEFAULT_SORT_COLUMN = "first_name".freeze
  private_constant :DEFAULT_SORT_COLUMN
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
  has_many :affiliations,
           ->{ order("affiliations.name ASC") },
           through: :loyalties
  has_many :residences
  has_many :locations,
           ->{ order("locations.name ASC") },
           through: :residences

  def self.search(search)
    query = includes(:locations, :affiliations)
    if search
      query.where(SEARCH_QUERY, search: "%#{search}%")
    else
      query
    end
  end

  def self.sort_column(sort_param)
    SORT_COLUMNS.include?(sort_param) ? sort_param : DEFAULT_SORT_COLUMN
  end

  def first_affiliation_name
    affiliations.first.name
  end

  def affiliation_names
    affiliations.map(&:name)
  end

  def first_location_name
    locations.first.name
  end

  def location_names
    locations.map(&:name)
  end
end
