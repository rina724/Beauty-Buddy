class Profile < ApplicationRecord
  belongs_to :mycosmetic, optional: true
  belongs_to :user
  has_many :profiles_ingredients, dependent: :destroy
  has_many :ingredients, through: :profiles_ingredients

  def ingredient_selected?(ingredient)
    return false unless ingredient
    ingredients.include?(ingredient)
  end
end
