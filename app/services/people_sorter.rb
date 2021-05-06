# frozen_string_literal: true

module PeopleSorter
  module_function

  def sort(people_relation, sort_column, sort_direction)
    sorted_people =
      people_relation
        .to_enum
        .with_object(sort_column)
        .sort_by(&method(:column_value))
        .map(&:first) # removes sort_column from with_object

    if sort_direction == Rails.configuration.descending
      sorted_people.reverse
    else
      sorted_people
    end
  end

  def column_value((person, sort_column))
    column_value = person.public_send(sort_column)
    # NOTE: Doing this ensures that `nil` values stay at the bottom of lists.
    [column_value ? 0 : 1, column_value]
  end
  private_class_method :column_value
end
