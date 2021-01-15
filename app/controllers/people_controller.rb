class PeopleController < ApplicationController
  helper_method :sort_column

  def index
    people =
      Person
        .includes(:locations, :affiliations)
        .search(params[:search])
        .to_a
    sorted_people = sorted_order(people)
    paginated_people =
      Kaminari.paginate_array(sorted_people).page(params[:page])

    @people =
      PersonDecorator.decorate_collection(
        paginated_people,
        context: { sort_column: sort_column, params: params }
      )
  end

  private

  def sorted_order(people)
    sorted_people =
      people.sort_by do |person|
        column_value = person.public_send(sort_column)
        [column_value ? 0 : 1, column_value]
      end
    if sort_direction == Rails.configuration.descending
      sorted_people.reverse
    else
      sorted_people
    end
  end

  def sort_column
    Person.sort_column(params[:sort])
  end
end
