class CreateProfilesIngredients < ActiveRecord::Migration[7.2]
  def change
    create_table :profiles_ingredients do |t|
      t.references :profile, foreign_key: true
      t.references :ingredient, foreign_key: true
      t.timestamps
    end
  end
end
