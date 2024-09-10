class CreateProfiles < ActiveRecord::Migration[7.2]
  def change
    create_table :profiles do |t|
      t.string :caution
      t.string :allergy
      t.references :mycosmetic, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
