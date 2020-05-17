class Art < ApplicationRecord
  # Art model belongs to user and has a picture
  belongs_to :user
  has_one_attached :picture
end
