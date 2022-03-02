class Card < ApplicationRecord
  scope :by_created, -> { order(created_at: :asc) }
  scope :most_recently_created, -> { by_created.last }

  before_create :set_pos
  before_update :update_pos

  belongs_to :list
  has_and_belongs_to_many :labels
  has_many :checklists, dependent: :destroy
  has_many :check_items, through: :checklists

  def set_pos
    if list.cards.count.zero?
      self.pos = 0
    elsif pos.nil?
      self.pos = list.cards.size - 1
    end
  end

  def update_pos
    self.pos = List.find(self.list_id).cards.order(:pos).last.pos + 1 if pos.blank?
  end
end
