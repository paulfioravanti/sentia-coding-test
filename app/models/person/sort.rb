# frozen_string_literal: true

class Person
  module Sort
    SORT_COLUMNS = %w[
      prefix
      first_name
      last_name
      suffix
      first_location_name
      species
      gender
      first_affiliation_name
      weapon
      vehicle
    ].freeze
    DEFAULT_SORT_COLUMN = "first_name"

    module_function

    def column(sort_param)
      SORT_COLUMNS.include?(sort_param) ? sort_param : DEFAULT_SORT_COLUMN
    end
  end
  private_constant :Sort
end
