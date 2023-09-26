# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :post

  validates_presence_of :name, :content
end
