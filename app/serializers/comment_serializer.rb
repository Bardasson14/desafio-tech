# frozen_string_literal: true

class CommentSerializer < ActiveModel::Serializer
  attributes :id, :name, :content, :post_id
end
