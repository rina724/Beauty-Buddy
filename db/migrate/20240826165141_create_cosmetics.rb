class CreateCosmetics < ActiveRecord::Migration[7.2]
  def change
    create_table :cosmetics do |t|
      t.string :product_name, null: false
      t.integer :amount, null: false
      t.string :ingredient, null: false
      t.string :image, null: false
      t.references :category, foreign_key: true
      t.references :brand, foreign_key: true
      t.timestamps
    end
    add_index :cosmetics, :product_name, unique: true
  end
end
