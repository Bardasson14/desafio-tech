class CommentSerializer < ActiveModel::Serializer
  attributes :id, :name, :content, :post_id
end
