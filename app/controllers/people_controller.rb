class PeopleController < ApplicationController
  helper_method :sort_column

  def index
    people =
      Person
        .includes(:locations, :affiliations)
        .sorted_order(params[:sort], sort_direction)
        .search(params[:search])
        .page(params[:page])

    @people = PersonDecorator.decorate_collection(people)
  end

  private

  def sort_column
    Person.sort_column(params[:sort])
  end
end
