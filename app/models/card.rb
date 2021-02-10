class Card < ApplicationRecord
  before_create :set_pos
  before_update :set_pos

  belongs_to :list
  has_and_belongs_to_many :labels
  has_many :checklists, dependent: :destroy
  has_many :check_items, through: :checklists

  def set_pos
    self.pos = list.cards.count + 1 if pos.nil?
  end
end
