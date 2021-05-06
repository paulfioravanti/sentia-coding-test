module DataImporter
  module EnumFieldParser
    INVALID_CHARACTERS = /[^a-z1-9\-' ]/i
    private_constant :INVALID_CHARACTERS
    MISSPELLINGS = {
      "Yoda's Hutt" => "Yoda's Hut",
      "Naboo N-1 Starfigher" => "Naboo N-1 Starfighter"
    }.freeze
    private_constant :MISSPELLINGS

    module_function

    def parse_multi_value_fields(enum_fields)
      enum_fields.each_with_object([], &method(:parse_enum_field))
    end

    def parse_single_value_fields(enum_fields)
      enum_fields.each_with_object([], &method(:parse_enum_field))
    end

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
end
