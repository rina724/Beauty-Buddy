class Cosmetic < ApplicationRecord
  validates :product_name, presence: true, uniqueness: true
  validates :amount, presence: true
  validates :ingredient, presence: true

  belongs_to :brand
  belongs_to :category
  has_one :mycosmetic
end
