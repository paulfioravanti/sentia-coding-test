class PeopleController < ApplicationController
  DEFAULT_SORT_COLUMN = "first_name".freeze
  private_constant :DEFAULT_SORT_COLUMN

  helper_method :sort_column, :sort_direction

  def index
    people =
      Person
        .includes(:locations, :affiliations)
        .order("#{sort_column} #{sort_direction}")

    @people = PersonDecorator.decorate_collection(people)
  end

  private

  def sort_column
    column = params[:sort]
    Person.column_names.include?(column) ? column : DEFAULT_SORT_COLUMN
  end

  def sort_direction
    direction = params[:direction]
    if Rails.configuration.sort_directions.include?(direction)
      direction
    else
      Rails.configuration.ascending
    end
  end
end
