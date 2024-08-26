class Cosmetic < ApplicationRecord
  validates :product_name, presence: true, uniqueness: true
  validates :amount, presence: true
  validates :ingredient, presence: true
  validates :image, presence: true

  belongs_to :brand
  belongs_to :category
end
