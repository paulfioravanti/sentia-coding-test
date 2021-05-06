# frozen_string_literal: true

module DataImporter
  module AffiliationsParser
    VALID_AFFILIATIONS = Affiliation.names.values.freeze
    private_constant :VALID_AFFILIATIONS

    module_function

    def parse(row)
      enum_fields = generate_enum_fields(row)
      affiliations = EnumFieldParser.parse_multi_value_fields(enum_fields)

      if affiliations.blank?
        Rails.logger.warn("Afilliations invalid. Skipping...")
        throw :next
      end

      affiliations
    end

    def generate_enum_fields(row)
      row["Affiliations"]
        .split(",")
        .map { |affiliation| [affiliation, VALID_AFFILIATIONS] }
    end
    private_class_method :generate_enum_fields
  end
end
