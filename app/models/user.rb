class User < ApplicationRecord
  has_many :reviews
  has_many :reviewed_recipes, through: :reviews, source: :recipe

  # Favorites (reviews where is_favorite=true)
  has_many :favorites, -> { where(is_favorite: true) }, class_name: "Review"
  has_many :favorite_recipes, through: :favorites, source: :recipe

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
