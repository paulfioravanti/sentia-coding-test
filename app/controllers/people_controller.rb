class PeopleController < ApplicationController
  helper_method :sort_column

  def index
    people = Person.search(params[:search])
    sorted_people = PeopleSorter.sort(people, sort_column, sort_direction)
    paginated_people =
      Kaminari.paginate_array(sorted_people).page(params[:page])

    @people =
      PersonDecorator.decorate_collection(
        paginated_people,
        context: { sort_column: sort_column, params: params }
      )
  end

  private

  def sort_column
    Person.sort_column(params[:sort])
  end
end
