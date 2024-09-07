class Mycosmetic < ApplicationRecord
  validates :cosmetic_id, uniqueness: { scope: :user_id }

  belongs_to :user
  belongs_to :cosmetic

  enum :problem, { good: 0, normal: 1,  bad: 2 }
end
