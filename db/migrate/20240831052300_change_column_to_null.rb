class ChangeColumnToNull < ActiveRecord::Migration[7.2]
  def change
    def up
      change_column_null :cosmetics, :image, true
    end

    def down
      change_column_null :cosmetics, :image, false
    end
  end
end
