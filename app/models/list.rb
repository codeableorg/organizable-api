class List < ApplicationRecord
  scope :by_created, -> { order(created_at: :asc) }
  scope :most_recently_created, -> { by_created.last }
  before_create :set_pos
  before_update :update_pos

  belongs_to :board
  has_many :cards, dependent: :destroy

  def set_pos
    if board.lists.count.zero?
      self.pos = 0
    elsif pos.nil?
      self.pos = board.lists.size - 1
    end
  end

  def update_pos
    self.pos = Board.find(self.board_id).lists.order(:pos).last.pos + 1 if pos.blank?
  end
end
