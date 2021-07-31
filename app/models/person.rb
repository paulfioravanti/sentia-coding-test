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

  attribute :first_affiliation_name, :string
  attribute :first_location_name, :string

  def self.search(search, column, direction)
    query =
      preload(:locations, :affiliations)
        .joins(:locations, :affiliations)
        .then(&Lateral.method(:join_first_association_names))
        .order(column => direction, Sort::DEFAULT_SORT_COLUMN => direction)
        .group(:id, :first_affiliation_name, :first_location_name)

    search ? Search.query(query, search) : query
  end

  def self.sort_column(sort_param)
    Sort.column(sort_param)
  end

  def self.sort_columns
    Sort::SORT_COLUMNS
  end

  def affiliation_names
    affiliations.map(&:name)
  end

  def location_names
    locations.map(&:name)
  end
end
