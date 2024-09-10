class ChangeAvatarColumnToNull < ActiveRecord::Migration[7.2]
  def change
    change_column_null :users, :avatar, true
  end
end
