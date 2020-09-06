class Post < ApplicationRecord
  # :title, :content, :code, :user
  acts_as_taggable

  belongs_to :user

  has_many :bookmarks, dependent: :destroy
  has_many :users, through: :bookmarks

  validates :title, {presence: true, length: {maximum: 100}}
  validates :content, {presence: true, length: {maximum: 2000}}
  validates :code, {presence: true, length: {maximum: 30000}}
end
