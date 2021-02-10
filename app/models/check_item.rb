class CheckItem < ApplicationRecord
  before_create :set_pos

  belongs_to :checklist

  def set_pos
    self.pos = checklist.check_items.count + 1
  end
end
