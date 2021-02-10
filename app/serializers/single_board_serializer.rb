class SingleBoardSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :name, :color, :starred, :closed, :created_at, :labels, :lists

  def lists
    object.lists.order(:pos).map do |list|
      {
        list_id: list.id,
        name: list.name,
        pos: list.pos,
        closed: list.closed,
        cards: list_cards(list)
      }
    end
  end

  def list_cards(list)
    list.cards.order(:pos).map do |card|
      {
        card_id: card.id,
        name: card.name,
        desc: card.desc,
        pos: card.pos,
        closed: card.closed,
        labels: list_labels(card),
        check_items: card.check_items.size,
        completed_check_items: card.check_items.where(completed: true).size
      }
    end
  end

  def list_labels(card)
    card.labels.map do |label|
      {
        label_id: label.id,
        name: label.name,
        color: label.color
      }
    end
  end

  def labels
    object.labels.map do |label|
      {
        id: label.id,
        name: label.name,
        color: label.color,
        board_id: label.board_id
      }
    end
  end

  # Todos los datos + un elemento list que tiene listas
  # Cada lista trae sus cards
  # Cada card trae sus labels en un arreglo
  # Cada card trae 2 atributos adicionales: checked_items, completed_checked_items
  # Cualquier atributo que tenga _ , convertirlo a camelCase

  # list: [
  #   {
  #     name: "dded",
  #     pos: 1,
  #     closed: false
  #     cards: [
  #       {
  #         name: "dwdeq",
  #         desc: "dedwe",
  #         ...,
  #         labels: [
  #           {...},
  #           {...},
  #           {...}
  #         ]
  #         check_items: 10,
  #         completed_check_items: 5
  #       }
  #     ]
  #   },
  #   {
  #     name: "dded",
  #     pos: 1,
  #     closed: false
  #     cards: [
  #       {
  #         name: "dwdeq",
  #         desc: "dedwe",
  #         ...,
  #         labels: [
  #           {...},
  #           {...},
  #           {...}
  #         ]
  #         check_items: 10,
  #         completed_check_items: 5
  #       }
  #     ]
  #   },

  # ]
end
