# frozen_string_literal: true

class Post < ApplicationRecord
  include Filter

  belongs_to :user
  has_many :comments, dependent: :destroy

  validates_presence_of :title, :content

  scope :filter_by_title, -> (title) { where("UNACCENT(title) ILIKE (?)", "%#{title}%") }
  scope :filter_by_content, -> (content) { where("UNACCENT(content) ILIKE (?)", "%#{content}%") }
  scope :filter_by_user_id, -> (user_id) { where(user_id:) }

  def self.filterable_columns
    %i[title content user_id]
  end

end
