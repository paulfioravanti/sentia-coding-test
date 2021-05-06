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
    private_constant :SORT_COLUMNS
    DEFAULT_SORT_COLUMN = "first_name"
    private_constant :DEFAULT_SORT_COLUMN

    module_function

    def column(sort_param)
      SORT_COLUMNS.include?(sort_param) ? sort_param : DEFAULT_SORT_COLUMN
    end
  end
  private_constant :Sort
end
