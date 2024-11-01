class Ingredient < ApplicationRecord
  has_many :cosmetic_ingredients
  has_many :cosmetics, through: :cosmetic_ingredients
  has_many :profiles_ingredients
  has_many :profiles, through: :profiles_ingredients
end
