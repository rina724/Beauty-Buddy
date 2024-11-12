class CreateMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :messages do |t|
      t.string :temp_usage
      t.string :temp_date
      t.string :temp_problem
      t.text :temp_memo
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
