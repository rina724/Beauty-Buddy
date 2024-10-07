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

  def self.ransackable_attributes(auth_object = nil)
    ["cosmetic_id", "id", "user_id"]
  end
  def self.ransackable_associations(auth_object = nil)
    ["cosmetic", "user"]
  end
end
