class Mycosmetic < ApplicationRecord
  validates :cosmetic_id, uniqueness: true

  belongs_to :user
  belongs_to :cosmetic

  enum :problem, { good: 0, normal: 1,  bad: 2 }
end
