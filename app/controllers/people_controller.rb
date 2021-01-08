class PeopleController < ApplicationController
  def index
    @people = Person.includes(:locations, :affiliations)
  end
end
