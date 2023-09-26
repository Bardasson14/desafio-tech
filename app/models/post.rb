class Post < ApplicationRecord
  belongs_to :user

  validates_presence_of :title, :content

  has_many :comments, dependent: :destroy
end
