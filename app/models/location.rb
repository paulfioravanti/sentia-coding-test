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
end
