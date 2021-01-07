module CSV
  module DataImporter
    module_function

    def import(file)
      CSV.parse(file.read, headers: true).each(&method(:process_row))
    end

    # NOTE: By necessity, the method has knowledge about the CSV fields and the
    # order of the columns.
    def process_row(row)
      name, location, species, gender, affiliations, weapon, vehicle = row
      # NOTE: A Person without an affiliation should be skipped.
      return if affiliations.blank?

      prefix, first_name, last_name, suffix = parse_name(name)
    end
    private_class_method :process_row

    def parse_name(name)
      name_parts = name.split.map(&:titleize)

      case name_parts
      in [name]
        [nil, name, nil, nil]
      in ["Darth"|"Princess" => prefix, *rest]
        [prefix, *rest]
      in [first_name, "The", "Hutt"]
        [nil, first_name, nil, "The Hutt"]
      else
        [nil, *name_parts, nil]
      end
    end
  end
end
