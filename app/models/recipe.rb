class Recipe < ApplicationRecord
  has_many :reviews
  has_many :users, through: :reviews

  # Helper method to convert ingredients_list into an array
  def ingredients
    ingredients_list.split(",")
  end

  validates :title, presence: true
  validates :cooking_time, numericality: { greater_than: 0 }
end
