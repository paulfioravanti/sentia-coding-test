# frozen_string_literal: true

class PeopleController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    @people =
      Person.search(params[:search])
        .then(&method(:sort_people))
        .then(&method(:paginate_people))
        .then(&method(:decorate_people))
  end

  private

  def sort_column
    @sort_column ||= Person.sort_column(params[:sort])
  end

  def sort_direction
    @sort_direction ||= SortDirection.determine(params[:direction])
  end

  def sort_people(people)
    PeopleSorter.sort(people, sort_column, sort_direction)
  end

  def paginate_people(sorted_people)
    Paginator.paginate_array(sorted_people, params[:page])
  end

  def decorate_people(paginated_people)
    PersonDecorator.decorate_collection(
      paginated_people,
      context: { sort_column: sort_column, params: params }
    )
  end
end
