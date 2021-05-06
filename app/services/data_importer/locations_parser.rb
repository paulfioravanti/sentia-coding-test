# frozen_string_literal: true

module DataImporter
  module LocationsParser
    VALID_LOCATIONS = Location.names.values.freeze
    private_constant :VALID_LOCATIONS

    module_function

    def parse(row)
      enum_fields = generate_enum_fields(row)
      locations = EnumFieldParser.parse_multi_value_fields(enum_fields)

      if locations.blank?
        Rails.logger.warn("Locations invalid. Skipping...")
        throw :next
      end

      locations
    end

    def generate_enum_fields(row)
      row["Location"]
        .split(",")
        .map { |affiliation| [affiliation, VALID_LOCATIONS] }
    end
    private_class_method :generate_enum_fields
  end
end
