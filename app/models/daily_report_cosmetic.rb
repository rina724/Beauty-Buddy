class DailyReportCosmetic < ApplicationRecord
  belongs_to :daily_report
  belongs_to :mycosmetic

  validates :daily_report_id, uniqueness: { scope: :mycosmetic_id }
end
