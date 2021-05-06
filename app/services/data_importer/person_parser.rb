# frozen_string_literal: true

module DataImporter
  module PersonParser
    VALID_SPECIES = Person.species.values.freeze
    private_constant :VALID_SPECIES
    VALID_WEAPONS = Person.weapons.values.freeze
    private_constant :VALID_WEAPONS
    VALID_VEHICLES = Person.vehicles.values.freeze
    private_constant :VALID_VEHICLES

    module_function

    def parse(row)
      prefix, first_name, last_name, suffix = parse_name(row["Name"])
      gender = parse_gender(row["Gender"])
      if gender.blank?
        Rails.logger.warn("Person has a invalid gender. Skipping...")
        throw :next
      end

      enum_fields = generate_enum_fields(row)
      species, weapon, vehicle =
        EnumFieldParser.parse_single_value_fields(enum_fields)
      if species.blank?
        Rails.logger.warn("Person has a invalid species. Skipping...")
        throw :next
      end

      {
        prefix: prefix,
        first_name: first_name,
        last_name: last_name,
        suffix: suffix,
        gender: gender,
        species: species,
        weapon: weapon,
        vehicle: vehicle
      }
    end

    def parse_name(name)
      name_parts = name.split.map(&:upcase_first)

      case name_parts
      in [name]
        [nil, name, nil, nil]
      in ["Darth" | "Princess" => prefix, *rest]
        [prefix, *rest]
      in [*first_names, "Ren" => suffix]
        [nil, first_names.join(" "), nil, suffix]
      in [*first_names, "The", "Hutt"]
        [nil, first_names.join(" "), nil, "The Hutt"]
      else
        *first_names, last_name = name_parts
        [nil, first_names.join(" "), last_name, nil]
      end
    end
    private_class_method :parse_name

    def parse_gender(gender)
      case gender
      in "Male" | "Female" | "Other" => gender
      gender
      in /\Am\z/i
      "Male"
      in /\Af\z/i
      "Female"
      else
        nil
      end
    end
    private_class_method :parse_gender

    def generate_enum_fields(row)
      row
        .values_at("Species", "Weapon", "Vehicle")
        .zip([VALID_SPECIES, VALID_WEAPONS, VALID_VEHICLES])
    end
    private_class_method :generate_enum_fields
  end
end
