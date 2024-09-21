class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :cosmetic

  validates :user_id, uniqueness: { scope: :cosmetic_id }
end
