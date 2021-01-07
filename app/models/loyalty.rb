class Loyalty < ApplicationRecord
  belongs_to :person
  belongs_to :affiliation
end
