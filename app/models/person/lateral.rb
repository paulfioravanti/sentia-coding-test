# frozen_string_literal: true

class Person
  module Lateral
    # References:
    # - Postgres Lateral Joins: https://heap.io/blog/postgresqls-powerful-new-join-type-lateral
    # - Rails Lateral joins: https://sambleckley.com/writing/lateral-in-rails.html
    # - Table aliases for removing parentheses in return values:
    #   - https://stackoverflow.com/q/67047907/567863
    #   - https://www.postgresql.org/docs/current/rowtypes.html#ROWTYPES-USAGE
    FIRST_ASSOCIATION_NAME =
      lambda do |query, table_alias, field|
        <<~SQL.squish
          JOIN LATERAL (#{query.to_sql})
          AS #{table_alias}(#{field})
          ON true
        SQL
      end
    private_constant :FIRST_ASSOCIATION_NAME

    module_function

    def join_first_association_names(query)
      query
        .joins(first_affiliation_name)
        .joins(first_location_name)
    end

    private_class_method def first_affiliation_name
      FIRST_ASSOCIATION_NAME.call(
        Affiliation.first_name,
        :affiliation,
        :first_affiliation_name
      )
    end

    private_class_method def first_location_name
      FIRST_ASSOCIATION_NAME.call(
        Location.first_name,
        :location,
        :first_location_name
      )
    end
  end
  private_constant :Lateral
end
