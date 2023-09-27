# frozen_string_literal: true

class Comment < ApplicationRecord
  include Filter

  belongs_to :post

  validates_presence_of :name, :content

  scope :filter_by_post_id, -> (post_id) { where post_id: }
  scope :filter_by_name, -> (name) { where("UNACCENT(name) ILIKE (?)", "%#{name}%") }
  scope :filter_by_content, -> (content) { where("UNACCENT(content) ILIKE (?)", "%#{content}%") }

  def self.filterable_columns
    %i[name content post_id]
  end
end
