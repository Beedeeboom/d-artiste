json.extract! art, :id, :title, :description, :size, :price, :user_id, :created_at, :updated_at
json.url art_url(art, format: :json)
