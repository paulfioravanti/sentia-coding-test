class PersonDecorator < Draper::Decorator
  delegate_all

  def self.collection_decorator_class
    PeopleDecorator
  end

  def location_names
    object.location_names.join(", ")
  end

  def affiliation_names
    object.affiliation_names.join(", ")
  end
end
