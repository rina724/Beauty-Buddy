class CosmeticIngredient < ApplicationRecord
  belongs_to :cosmetic
  belongs_to :ingredient
end
