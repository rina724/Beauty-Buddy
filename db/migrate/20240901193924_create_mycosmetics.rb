class CreateMycosmetics < ActiveRecord::Migration[7.2]
  def change
    create_table :mycosmetics do |t|
      t.boolean :usage_situation
      t.date :starting_date
      t.integer :problem
      t.text :memo
      t.references :user, foreign_key: true
      t.references :cosmetic, foreign_key: true
      t.timestamps
    end
  end
end
