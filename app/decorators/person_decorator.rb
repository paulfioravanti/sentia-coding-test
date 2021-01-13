class PersonDecorator < Draper::Decorator
  delegate_all

  def self.collection_decorator_class
    PeopleDecorator
  end

  def location_names
    object.locations.map(&:name).join(", ")
  end

  def affiliation_names
    object.affiliations.map(&:name).join(", ")
  end
end
