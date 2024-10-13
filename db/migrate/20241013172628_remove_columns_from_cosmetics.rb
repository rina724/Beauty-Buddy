class RemoveColumnsFromCosmetics < ActiveRecord::Migration[7.2]
  def change
    remove_column :cosmetics, :amount, :integer
    remove_column :cosmetics, :ingredient, :string
  end
end
