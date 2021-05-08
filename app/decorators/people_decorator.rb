# frozen_string_literal: true

class PeopleDecorator < Draper::CollectionDecorator
  ASCENDING = Rails.configuration.ascending
  private_constant :ASCENDING
  DESCENDING = Rails.configuration.descending
  private_constant :DESCENDING

  delegate :current_page,
           :total_pages,
           :limit_value,
           :entry_name,
           :total_count,
           :offset_value,
           :last_page?

  def sortable_headers
    context[:sort_columns]
      .map(&method(:sortable_header))
      .then(&helpers.method(:safe_join))
  end

  private

  def sortable_header(column)
    title = header_title(column)
    column_params = generate_params(column)

    helpers.content_tag(:th, scope: "col", class: "person-heading") do
      helpers.link_to(title, column_params, { class: "hover:underline" })
    end
  end

  def header_title(column)
    case column
    when "first_location_name" then "Locations"
    when "first_affiliation_name" then "Affiliations"
    else column.titleize
    end
  end

  def generate_params(column)
    direction = current_column_ascending?(column) ? DESCENDING : ASCENDING

    context[:params]
      .permit(:sort, :direction, :page, :search)
      .merge({ sort: column, direction: direction, page: nil })
  end

  def current_column_ascending?(column)
    column == context[:sort_column] && context[:sort_direction] == ASCENDING
  end
end
