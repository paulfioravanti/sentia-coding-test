require "csv"

module DataImporter
  INVALID_CHARACTERS =/[^a-z1-9\-\' ]/i
  private_constant :INVALID_CHARACTERS
  VALID_SPECIES = Person.species.values.freeze
  private_constant :VALID_SPECIES
  VALID_WEAPONS = Person.weapons.values.freeze
  private_constant :VALID_WEAPONS
  VALID_VEHICLES = Person.vehicles.values.freeze
  private_constant :VALID_VEHICLES
  VALID_LOCATIONS = Location.names.values.freeze
  private_constant :VALID_LOCATIONS
  VALID_AFFILIATIONS = Affiliation.names.values.freeze
  private_constant :VALID_AFFILIATIONS
  MISSPELLINGS = {
    "Yoda's Hutt" => "Yoda's Hut",
    "Naboo N-1 Starfigher" => "Naboo N-1 Starfighter"
  }
  private_constant :MISSPELLINGS

  module_function

  def import(file)
    file.rewind
    CSV.parse(file.read, headers: false).each(&method(:process_row))
  end

  # NOTE: By necessity, the method has knowledge about the CSV fields and the
  # order of the columns.
  def process_row(row)
    Rails.logger.error("Processing #{row}")
    # NOTE: A Person without an affiliation should be skipped, but we'll also
    # just ensure we have values for *all* the required fields.
    if row.first(5).any?(&:blank?)
      Rails.logger.error("#{row} contains blank values. Skipping...")
      return
    end
    name, locations, species, gender, affiliations, weapon, vehicle = row

    prefix, first_name, last_name, suffix = parse_name(name)

    gender = parse_gender(gender)
    if gender.blank?
      Rails.logger.error("#{row} has a blank gender. Skipping...")
      return
    end

    person_enum_fields =
      [
        [species, VALID_SPECIES],
        [weapon, VALID_WEAPONS],
        [vehicle, VALID_VEHICLES],
      ].each_with_object([], &method(:parse_enum_field))
    # NOTE: Only need to abort if species is blank
    if person_enum_fields.first.blank?
      Rails.logger.error("#{person_enum_fields} has a blank species. Skipping...")
      return
    end

    species, weapon, vehicle = person_enum_fields

    multi_enum_fields =
      [
        [locations.split(","), VALID_LOCATIONS],
        [affiliations.split(","), VALID_AFFILIATIONS],
      ].each_with_object([], &method(:parse_enum_fields))
    if multi_enum_fields.flatten.any?(&:blank?)
      Rails.logger.error("#{multi_enum_fields} has blank values. Skipping...")
      return
    end

    locations, affiliations = multi_enum_fields

    person =
      Person.create!(
        prefix: prefix,
        first_name: first_name,
        last_name: last_name,
        suffix: suffix,
        species: species,
        gender: gender,
        weapon: weapon,
        vehicle: vehicle
      )

    locations.each do |location|
      person.residences.create!(location: Location.find_by(name: location))
    end
    affiliations.each do |affiliation|
      person.loyalties.create!(affiliation: Affiliation.find_by(name: affiliation))
    end
  end
  private_class_method :process_row

  def parse_name(name)
    name_parts = name.split.map(&:upcase_first)

    case name_parts
    in [name]
      [nil, name, nil, nil]
    in ["Darth" | "Princess" => prefix, *rest]
      [prefix, *rest]
    in [*first_names, "Ren"]
      [nil, first_names.join(" "), nil, "Ren"]
    in [first_name, "The", "Hutt"]
      [nil, first_name, nil, "The Hutt"]
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

  def parse_enum_fields((fields, valid_enums), acc)
    Rails.logger.info("fields: #{fields}, valid_enums: #{valid_enums}")
    parsed_fields =
      fields
        .each
        .with_object(valid_enums)
        .each_with_object([], &method(:parse_enum_field))

    acc << parsed_fields
  end
  private_class_method :parse_enum_fields

  def parse_enum_field((field, valid_enums), acc)
    Rails.logger.info("field: #{field}, valid_enums: #{valid_enums}")
    munged_field = munge_field(field)
    Rails.logger.info("munged_field: #{munged_field}")
    acc << (valid_enums.include?(munged_field) ? munged_field : nil)
  end
  private_class_method :parse_enum_field

  def munge_field(field)
    munged_field =
      field
        .to_s
        .gsub(INVALID_CHARACTERS, "")
        .strip
        .upcase_first

    MISSPELLINGS[munged_field] || munged_field
  end
  private_class_method :munge_field
end
