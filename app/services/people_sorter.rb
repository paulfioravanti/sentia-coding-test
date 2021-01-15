module PeopleSorter
  module_function

  def sort(people_relation, sort_column, sort_direction)
    sorted_people =
      people_relation.to_a.sort_by do |person|
        column_value = person.public_send(sort_column)
        [column_value ? 0 : 1, column_value]
      end

    if sort_direction == Rails.configuration.descending
      sorted_people.reverse
    else
      sorted_people
    end
  end
end
