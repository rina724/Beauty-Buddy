class Cosmetic < ApplicationRecord
  validates :product_name, presence: true, uniqueness: true

  belongs_to :brand
  belongs_to :category
  has_one :mycosmetic
  has_many :favorites
  has_many :users, through: :favorites
  has_many :cosmetic_ingredients
  has_many :ingredients, through: :cosmetic_ingredients

  def self.ransackable_attributes(auth_object = nil)
    [ "id", "product_name", "brand_id", "category_id" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "category", "brand" ]
  end
end
