class List < ApplicationRecord
  before_create :set_pos

  belongs_to :board
  has_many :cards, dependent: :destroy

  def set_pos
    self.pos = board.lists.last.pos + 1
  end
end
