# frozen_string_literal: true

class Person
  module Search
    SEARCH_QUERY =
      "prefix ILIKE :search "\
      "OR first_name ILIKE :search "\
      "OR last_name ILIKE :search "\
      "OR suffix ILIKE :search "\
      "OR locations.name::text ILIKE :search "\
      "OR species::text ILIKE :search "\
      "OR gender::text ILIKE :search "\
      "OR affiliations.name::text ILIKE :search "\
      "OR weapon::text ILIKE :search "\
      "OR vehicle::text ILIKE :search"
    private_constant :SEARCH_QUERY

    module_function

    def query(query, search)
      query.where(SEARCH_QUERY, search: "%#{search}%")
    end
  end
  private_constant :Search
end
