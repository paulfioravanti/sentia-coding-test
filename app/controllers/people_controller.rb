class PeopleController < ApplicationController
  def index
    order = params[:order] || :first_name
    people = Person.includes(:locations, :affiliations).order(order)
    @people = PersonDecorator.decorate_collection(people)
  end
end
