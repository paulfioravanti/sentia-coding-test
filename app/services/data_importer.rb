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
    CSV.parse(file.read, headers: true).each(&method(:process_row))
  end

  # NOTE: By necessity, the method has knowledge about the CSV fields and the
  # order of the columns.
  def process_row(row)
    Rails.logger.info("Processing #{row}")
    # NOTE: A Person without an affiliation should be skipped, but we'll also
    # just ensure we have values for *all* the required fields.
    if required_fields_blank?(row)
      Rails.logger.warn("#{row} contains blank required fields. Skipping...")
      return
    end

    prefix, first_name, last_name, suffix = parse_name(row["Name"])

    gender = parse_gender(row["Gender"])
    if gender.blank?
      Rails.logger.warn("#{row} has a blank gender. Skipping...")
      return
    end

    species, weapon, vehicle = parse_single_value_enum_fields(row)
    if species.blank?
      Rails.logger.warn("#{row} has a blank species. Skipping...")
      return
    end

    locations, affiliations = parse_multi_value_enum_fields(row)
    if [*locations, *affiliations].any?(&:blank?)
      Rails.logger.warn(
        "#{row} has a blank location or affiliations. Skipping..."
      )
      return
    end

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

    locations.each do |location_name|
      location = Location.find_or_create_by(name: location_name)
      person.residences.create!(location: location)
    end
    affiliations.each do |affiliation_name|
      affiliation = Affiliation.find_or_create_by(name: affiliation_name)
      person.loyalties.create!(affiliation: affiliation)
    end
  end
  private_class_method :process_row

  def required_fields_blank?(row)
    row
      .first(5)
      .map(&:second)
      .any?(&:blank?)
  end
  private_class_method :required_fields_blank?

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

  def parse_single_value_enum_fields(row)
    species, weapon, vehicle = row.values_at("Species", "Weapon", "Vehicle")
    enum_fields =
      [
        [species, VALID_SPECIES],
        [weapon, VALID_WEAPONS],
        [vehicle, VALID_VEHICLES],
      ]

    enum_fields.each_with_object([], &method(:parse_enum_field))
  end
  private_class_method :parse_single_value_enum_fields

  def parse_multi_value_enum_fields(row)
    locations, affiliations =
      row
        .values_at("Location", "Affiliations")
        .map { |value| value.split(",") }
    enum_fields =
      [[locations, VALID_LOCATIONS], [affiliations, VALID_AFFILIATIONS]]

    enum_fields.each_with_object([], &method(:parse_enum_fields))
  end
  private_class_method :parse_multi_value_enum_fields

  def parse_enum_fields((fields, valid_enums), acc)
    parsed_fields =
      fields
        .each
        .with_object(valid_enums)
        .each_with_object([], &method(:parse_enum_field))

    acc << parsed_fields
  end
  private_class_method :parse_enum_fields

  def parse_enum_field((field, valid_enums), acc)
    munged_field = munge_field(field)
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
