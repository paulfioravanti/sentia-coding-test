# frozen_string_literal: true

class Residence < ApplicationRecord
  belongs_to :person
  belongs_to :location
end
