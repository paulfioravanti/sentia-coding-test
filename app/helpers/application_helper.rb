module ApplicationHelper
  def link_to_sortable(column, title = nil)
    title ||= column.titleize
    direction =
      if current_column_ascending?(column)
        Rails.configuration.descending
      else
        Rails.configuration.ascending
      end
    column_params =
      params
        .permit(:sort, :direction, :page, :search)
        .merge({ sort: column, direction: direction, page: nil })

    link_to(title, column_params, { class: "hover:underline" })
  end

  def current_column_ascending?(column)
    column == sort_column && sort_direction == Rails.configuration.ascending
  end
end
