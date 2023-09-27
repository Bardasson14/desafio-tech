# frozen_string_literal: true

class User < ApplicationRecord
  include Filter
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :posts, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  validates_confirmation_of :password
  validates_presence_of :name

  scope :filter_by_name, -> (name) { where("UNACCENT(name) ILIKE (?)", "%#{name}%") }
  scope :filter_by_email, -> (email) { where("UNACCENT(email) ILIKE (?)", "%#{email}%") }

  def self.filterable_columns
    %i[name email]
  end
end
