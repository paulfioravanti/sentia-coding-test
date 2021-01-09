class PeopleDecorator < Draper::CollectionDecorator
  delegate :current_page,
           :total_pages,
           :limit_value,
           :entry_name,
           :total_count,
           :offset_value,
           :last_page?

  def link_to_sortable(column, title = nil)
    title ||= column.titleize
    direction = determine_direction(column)
    column_params = generate_params(column, direction)

    helpers.link_to(title, column_params, { class: "hover:underline" })
  end

  private

  def determine_direction(column)
    if current_column_ascending?(column)
      Rails.configuration.descending
    else
      Rails.configuration.ascending
    end
  end

  def current_column_ascending?(column)
    column == context[:sort_column] &&
      helpers.sort_direction == Rails.configuration.ascending
  end

  def generate_params(column, direction)
    context[:params]
      .permit(:sort, :direction, :page, :search)
      .merge({ sort: column, direction: direction, page: nil })
  end
end
