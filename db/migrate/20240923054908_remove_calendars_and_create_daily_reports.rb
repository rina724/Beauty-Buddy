class RemoveCalendarsAndCreateDailyReports < ActiveRecord::Migration[7.2]
  def change
    # Calendarsテーブルの削除
    drop_table :calendars

    # Daily Reportsテーブルの作成
    create_table :daily_reports do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :start_time, null: false
      t.integer :health
      t.text :memo
      t.integer :date_amount
      t.references :mycosmetic, foreign_key: true

      t.timestamps
    end

    add_index :daily_reports, [ :user_id, :start_time ], unique: true

    create_table :daily_report_cosmetics do |t|
      t.references :daily_report, null: false, foreign_key: true
      t.references :mycosmetic, null: false, foreign_key: true

      t.timestamps
    end

    add_index :daily_report_cosmetics, [ :daily_report_id, :mycosmetic_id ], unique: true, name: 'index_daily_report_cosmetics_uniqueness'
  end
end
