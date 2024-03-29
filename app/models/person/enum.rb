# frozen_string_literal: true

class Person
  module Enum
    SPECIES = [
      "Astromech Droid",
      "Gungan",
      "Human",
      "Hutt",
      "Protocol Droid",
      "Unknown",
      "Wookie"
    ].freeze
    GENDERS = %w[Male Female Other].freeze
    WEAPONS = [
      "Blaster",
      "Blaster Pistol",
      "Bowcaster",
      "Energy Ball",
      "Lightsaber"
    ].freeze
    VEHICLES = [
      "Gungan Bongo Submarine",
      "Jabba's Sail Barge",
      "Jedi Starfighter",
      "Millennium Falcon",
      "Naboo N-1 Starfighter",
      "Rey's Speeder",
      "Slave 1",
      "TIE Fighter",
      "X-wing Starfighter"
    ].freeze
  end
  private_constant :Enum
end
