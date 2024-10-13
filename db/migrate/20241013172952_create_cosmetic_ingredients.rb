class CreateCosmeticIngredients < ActiveRecord::Migration[7.2]
  def change
    create_table :cosmetic_ingredients do |t|
      t.references :cosmetic, null: false, foreign_key: true
      t.references :ingredient, null: false, foreign_key: true

      t.timestamps
    end
    add_index :cosmetic_ingredients, [:cosmetic_id, :ingredient_id], unique: true
  end
end
