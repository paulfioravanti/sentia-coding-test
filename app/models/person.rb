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
      eager_load(:locations, :affiliations)
        .joins(first_affiliation_name)
        .joins(first_location_name)
        .order(column => direction, Sort::DEFAULT_SORT_COLUMN => direction)

    search ? Search.query(query, search) : query
  end

  def self.sort_column(sort_param)
    Sort.column(sort_param)
  end

  def self.sort_columns
    Sort::SORT_COLUMNS
  end

  private_class_method def self.first_affiliation_name
    first_affiliation_name_query = Affiliation.first_name_query
    <<~SQL.squish
      JOIN LATERAL (#{first_affiliation_name_query})
      AS affiliation(first_affiliation_name)
      ON true
    SQL
  end

  private_class_method def self.first_location_name
    first_location_name_query = Location.first_name_query
    <<~SQL.squish
      JOIN LATERAL (#{first_location_name_query})
      AS location(first_location_name)
      ON true
    SQL
  end

  def affiliation_names
    affiliations.map(&:name)
  end

  def location_names
    locations.map(&:name)
  end
end
