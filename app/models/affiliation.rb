# frozen_string_literal: true

class Affiliation < ApplicationRecord
  NAMES = [
    "First Order",
    "Galactic Republic",
    "Gungan Grand Army",
    "Hutt Clan",
    "Jedi Order",
    "Rebel Alliance",
    "Sith",
    "The Resistance"
  ].freeze
  private_constant :NAMES

  include PGEnum(name: NAMES)

  has_many :loyalties
  has_many :people, through: :loyalties
end
