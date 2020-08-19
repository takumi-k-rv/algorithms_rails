class User < ApplicationRecord
  # :name, :email, :image_name, :password_digest
  has_secure_password

  validates :name, {presence: true}
  validates :email, {presence: true, uniqueness: true}

end
