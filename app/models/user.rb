class User < ApplicationRecord
  # :name, :email, :image_name, :password_digest
  has_secure_password

  has_many :posts, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :posts, through: :bookmarks

  validates :name, {presence: true}
  validates :email, {presence: true, uniqueness: true}

   def posts
    return Post.where(user_id: self.id)
  end

end
