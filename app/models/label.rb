class Label < ApplicationRecord
  belongs_to :board
  has_and_belongs_to_many :cards
  before_destroy { cards.clear }
end
