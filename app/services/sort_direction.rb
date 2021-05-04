module SortDirection
  SORT_DIRECTIONS = Rails.configuration.sort_directions
  private_constant :SORT_DIRECTIONS
  ASCENDING = Rails.configuration.ascending
  private_constant :ASCENDING

  module_function

  def determine(direction)
    SORT_DIRECTIONS.include?(direction) ? direction : ASCENDING
  end
end
