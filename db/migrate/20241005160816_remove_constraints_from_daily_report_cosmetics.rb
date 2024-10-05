class RemoveConstraintsFromDailyReportCosmetics < ActiveRecord::Migration[7.2]
  def change
    # ユニーク制約を削除
    remove_index :daily_report_cosmetics, name: "index_daily_report_cosmetics_uniqueness"

    # null: false 制約を削除
    change_column_null :daily_report_cosmetics, :daily_report_id, true
    change_column_null :daily_report_cosmetics, :mycosmetic_id, true

    # 新しいインデックスを追加（ユニーク制約なし）
    add_index :daily_report_cosmetics, [ :daily_report_id, :mycosmetic_id ], name: "index_on_daily_report_id_and_mycosmetic_id"
  end
end
