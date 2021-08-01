# frozen_string_literal: true

class Person
  module Lateral
    module_function

    def join_first_association_names(query)
      query
        .joins(first_affiliation_name)
        .joins(first_location_name)
    end

    private_class_method def first_affiliation_name
      first_association_name(
        Affiliation.first_name,
        :affiliation,
        :first_affiliation_name
      )
    end

    private_class_method def first_location_name
      first_association_name(
        Location.first_name,
        :location,
        :first_location_name
      )
    end

    private_class_method def first_association_name(
      query, table_name, field_name
    )
      <<~SQL.squish
        JOIN LATERAL (#{query.to_sql})
        AS #{table_name}(#{field_name})
        ON true
      SQL
    end
  end
  private_constant :Lateral
end
