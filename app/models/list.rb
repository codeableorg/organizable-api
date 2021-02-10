class List < ApplicationRecord
  scope :by_created, -> { order(created_at: :asc) }
  scope :most_recently_created, -> { by_created.last }
  before_create :set_pos
  before_update :update_pos

  belongs_to :board
  has_many :cards, dependent: :destroy

  def set_pos
    if board.lists.count.zero?
      self.pos = 1
    elsif pos.nil?
      self.pos = board.lists.most_recently_created.pos + 1
    end
  end

  def update_pos
    self.pos = board.lists.last.pos + 1 if pos.nil?
  end
end
