module ApplicationHelper
  def link_to_sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction =
      if column == sort_column && sort_direction == Rails.configuration.ascending
        Rails.configuration.descending
      else
        Rails.configuration.ascending
      end
    link_to(
      title,
      { sort: column, direction: direction },
      { class: "hover:underline" }
    )
  end
end
