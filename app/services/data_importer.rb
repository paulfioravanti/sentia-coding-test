require "csv"

module DataImporter
  REQUIRED_NUMBER_OF_FIELDS = 5
  private_constant :REQUIRED_NUMBER_OF_FIELDS

  module_function

  def import(file)
    file.rewind
    CSV.parse(file.read, headers: true).each(&method(:process_row))
  end

  # NOTE: By necessity, the method has knowledge about the CSV fields and the
  # order of the columns.
  def process_row(row)
    catch(:next) do
      Rails.logger.info("Processing #{row}")
      # NOTE: A Person without an affiliation should be skipped, but we'll also
      # just ensure we have values for *all* the required fields.
      if required_fields_blank?(row)
        Rails.logger.warn("#{row} contains blank required fields. Skipping...")
        return
      end

      person_attributes = PersonParser.parse(row)
      person = Person.find_or_create_by(person_attributes)
      generate_locations(row, person)
      generate_affiliations(row, person)
    end
  end
  private_class_method :process_row

  def required_fields_blank?(row)
    row
      .first(REQUIRED_NUMBER_OF_FIELDS)
      .map(&:second) # first value is the CSV header, second is the value
      .any?(&:blank?)
  end
  private_class_method :required_fields_blank?

  def generate_locations(row, person)
    location_names = LocationsParser.parse(row)
    location_names.each do |location_name|
      location = Location.find_or_create_by(name: location_name)
      person.residences.find_or_create_by(location: location)
    end
  end
  private_class_method :generate_locations

  def generate_affiliations(row, person)
    affiliation_names = AffiliationsParser.parse(row)
    affiliation_names.each do |affiliation_name|
      affiliation = Affiliation.find_or_create_by(name: affiliation_name)
      person.loyalties.find_or_create_by(affiliation: affiliation)
    end
  end
  private_class_method :generate_affiliations
end
