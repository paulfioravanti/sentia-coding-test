# frozen_string_literal: true

class PeopleController < ApplicationController
  def index
    @people =
      Person.search(params[:search], sort_column, sort_direction)
        .page(params[:page])
        .then(&method(:decorate_people))
  end

  private

  def sort_column
    @sort_column ||= Person.sort_column(params[:sort])
  end

  def sort_direction
    @sort_direction ||= SortDirection.determine(params[:direction])
  end

  def decorate_people(paginated_people)
    PersonDecorator.decorate_collection(
      paginated_people,
      context: {
        sort_column: sort_column,
        sort_columns: Person.sort_columns,
        sort_direction: sort_direction,
        header_params: params.permit(:sort, :direction, :page, :search)
      }
    )
  end
end
