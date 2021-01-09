class PersonDecorator < Draper::Decorator
  delegate_all
  decorates_association :locations
  decorates_association :affiliations

  def full_name
    object.name_parts.join(" ")
  end

  def location_names
    object.locations.map(&:name).join(", ")
  end

  def affiliation_names
    object.affiliations.map(&:name).sort.join(", ")
  end
end
