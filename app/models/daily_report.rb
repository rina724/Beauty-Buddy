class Dailyreport < ApplicationRecord
  belongs_to :user
  has_many :daily_report_cosmetics
  has_many :mycosmetics, through: :daily_report_cosmetics

  enum health: {
    very_bad: 0,
    bad: 1,
    normal: 2,
    good: 3,
    very_good: 4
  }

  validates :start_time, presence: true, uniqueness: { scope: :user_id }
end