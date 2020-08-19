json.extract! user, :id, :name, :email, :image_name, :password_digest, :created_at, :updated_at
json.url user_url(user, format: :json)
