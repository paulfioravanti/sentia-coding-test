class PeopleController < ApplicationController
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
    Person.column_names.include?(params[:sort]) ? params[:sort] : "first_name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
