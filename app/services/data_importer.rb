require "csv"

module DataImporter
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
      locations = LocationsParser.parse(row)
      affiliations = AffiliationsParser.parse(row)

      person = Person.upsert(person_attributes)
      locations.each do |location_name|
        location = Location.find_or_create_by(name: location_name)
        person.residences.find_or_create_by(location: location)
      end
      affiliations.each do |affiliation_name|
        affiliation = Affiliation.find_or_create_by(name: affiliation_name)
        person.loyalties.find_or_create_by(affiliation: affiliation)
      end
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
end
