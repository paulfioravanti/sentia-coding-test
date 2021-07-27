# frozen_string_literal: true

class Person < ApplicationRecord
  include PGEnum(
    species: Enum::SPECIES,
    gender: Enum::GENDERS,
    weapon: Enum::WEAPONS,
    vehicle: Enum::VEHICLES
  )

  has_many :loyalties
  has_many :affiliations, -> { order(:name) }, through: :loyalties
  has_many :residences
  has_many :locations, -> { order(:name) }, through: :residences

  def self.search(search)
    # NOTE: `includes`/`references` combo cannot be used since it seems
    # to ignore the ordering clause in the has_many relationships.
    # So, we have to use the more query-inefficient `preload`:(
    # More info at:
    # https://github.com/rails/rails/issues/6769
    # https://stackoverflow.com/a/11947303/567863
    query =
      preload(:locations, :affiliations)

    search ? Search.query(query, search) : query
  end

  def self.sort_column(sort_param)
    Sort.column(sort_param)
  end

  def self.sort_columns
    Sort::SORT_COLUMNS
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
