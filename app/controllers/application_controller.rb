class ApplicationController < ActionController::Base
  ASCENDING = "asc".freeze
  private_constant :ASCENDING
  DESCENDING = "desc".freeze
  private_constant :DESCENDING
  SORT_DIRECTIONS = %w(ASCENDING DESCENDING).freeze
  private_constant :SORT_DIRECTIONS
end
