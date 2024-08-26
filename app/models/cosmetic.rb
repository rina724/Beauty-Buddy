class Cosmetic < ApplicationRecord
  validates :product_name, presence: true, uniqueness: true
  validates :amount, presence: true
  validates :ingredient, presence: true
  validates :image, presence: true
end
