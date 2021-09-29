class ListSerializer < ActiveModel::Serializer
  attributes :id, :board_id, :name, :pos
end
