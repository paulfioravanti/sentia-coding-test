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
    # NOTE: preload needed to be used over `includes`/`references` combination
    # due to losing ordering clause on `locations` and `affiliations`
    # associations. More info at:
    # https://github.com/rails/rails/issues/6769
    # https://github.com/rails/rails/issues/8663
    # https://stackoverflow.com/a/11947303/567863
    query =
      preload(:affiliations, :locations)
        .then(&Lateral.method(:join_first_association_names))
        .order(column => direction, Sort::DEFAULT_SORT_COLUMN => direction)

      search.present? ? Search.query(query, search) : query
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
