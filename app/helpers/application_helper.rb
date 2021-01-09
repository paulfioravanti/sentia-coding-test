module ApplicationHelper
  def link_to_sortable(column, title = nil)
    title ||= column.titleize
    direction =
      if column == sort_column && sort_direction == Rails.configuration.ascending
        Rails.configuration.descending
      else
        Rails.configuration.ascending
      end
    link_to(
      title,
      params.permit(:sort, :direction, :page, :search).merge({ sort: column, direction: direction, page: nil }),
      { class: "hover:underline" }
    )
  end
end
