class Review < ApplicationRecord
  belongs_to :user
  belongs_to :recipe

  validates :rating, numericality: {
    only_integer: true,
    greater_than: 0,
    less_than_or_equal_to: 5
  }
  validates :comment, length: { maximum: 500 }
end
