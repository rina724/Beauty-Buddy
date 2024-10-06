class Cosmetic < ApplicationRecord
  validates :product_name, presence: true, uniqueness: true
  validates :amount, presence: true
  validates :ingredient, presence: true

  belongs_to :brand
  belongs_to :category
  has_one :mycosmetic
  has_many :favorites
  has_many :users, through: :favorites

  def self.ransackable_attributes(auth_object = nil)
    ["brand", "category", "product_name"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["category", "brand"]
  end
end
