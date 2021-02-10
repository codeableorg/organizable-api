class CardSerializer < ActiveModel::Serializer
  attributes :id, :list_id, :name, :desc, :pos, :closed, :checklists, :labels

  def checklists
    object.checklists.order(:pos).map do |checklist|
      {
        checklist_id: checklist.id,
        name: checklist.name,
        pos: checklist.pos,
        check_items: list_check_items(checklist)
      }
    end
  end

  def list_check_items(checklist)
    checklist.check_items.order(:pos).map do |check_item|
      {
        check_item_id: check_item.id,
        name: check_item.name,
        pos: check_item.pos,
        completed: check_item.completed
      }
    end
  end
end
