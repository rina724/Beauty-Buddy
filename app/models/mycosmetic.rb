class Mycosmetic < ApplicationRecord
  validates :cosmetic_id, uniqueness: { scope: :user_id }

  belongs_to :user
  belongs_to :cosmetic
  has_many :favorites, through: :user
  has_many :profiles
  has_many :daily_report_cosmetics, dependent: :nullify
  has_many :daily_report, through: :daily_report_cosmetics

  enum :problem, { good: 0, normal: 1,  bad: 2 }

  scope :for_daily_use, -> { where(usage_situation: true) }
end
