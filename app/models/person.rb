class Person < ApplicationRecord
  include PGEnum(
    species: Enum::SPECIES,
    gender: Enum::GENDERS,
    weapon: Enum::WEAPONS,
    vehicle: Enum::VEHICLES
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
    query =
      includes(:locations, :affiliations)
        .references(:locations, :affiliations)

    search ? Search.query(query, search) : query
  end

  def self.sort_column(sort_param)
    Sort.column(sort_param)
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
