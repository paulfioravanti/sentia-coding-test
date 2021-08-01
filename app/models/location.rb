# frozen_string_literal: true

class Location < ApplicationRecord
  NAMES = [
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
  ].freeze
  private_constant :NAMES

  include PGEnum(name: NAMES)

  has_many :residences
  has_many :people, through: :residences

  def self.first_name
    joins(:residences)
      .where("residences.person_id = people.id")
      .order(:name)
      .limit(1)
      .select(:name)
  end
end
