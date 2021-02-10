class AllBoardsSerializer < ActiveModel::Serializer
  attributes :id, :name, :closed, :color, :starred, :created_at
end
