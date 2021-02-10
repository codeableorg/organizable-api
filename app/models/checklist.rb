class Checklist < ApplicationRecord
  before_create :set_pos

  belongs_to :card
  has_many :check_items, dependent: :destroy

  def set_pos
    self.pos = card.checklists.count + 1
  end
end
