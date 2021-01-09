class PeopleController < ApplicationController
  def index
    people = Person.includes(:locations, :affiliations)
    @people = PersonDecorator.decorate_collection(people)
  end
end
