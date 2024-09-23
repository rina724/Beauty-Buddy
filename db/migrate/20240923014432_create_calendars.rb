class CreateCalendars < ActiveRecord::Migration[7.2]
  def change
    create_table :calendars do |t|
      t.references :user, null: false, foreign_key: true
      t.date :record_date, null: false
      t.timestamps
    end
    add_index :calendars, [:user_id, :record_date], unique: true
  end
end
