class Post < ApplicationRecord
  # :title, :content, :code, :user
  belongs_to :user

  validates :title, {presence: true, length: {maximum: 100}}
  validates :content, {presence: true, length: {maximum: 2000}}
  validates :code, {presence: true, length: {maximum: 30000}}
end
