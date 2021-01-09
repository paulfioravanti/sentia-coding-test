class ApplicationController < ActionController::Base
  helper_method :sort_direction

  def sort_direction
    direction = params[:direction]
    if Rails.configuration.sort_directions.include?(direction)
      direction
    else
      Rails.configuration.ascending
    end
  end
end
