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

  def sortable_header(column, title = nil)
    title ||= column.titleize
    column_params = generate_params(column)

    helpers.content_tag(:th, scope: "col", class: "person-heading") do
      helpers.link_to(title, column_params, { class: "hover:underline" })
    end
  end

  private

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
