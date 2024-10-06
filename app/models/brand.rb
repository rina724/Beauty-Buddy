class Brand < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :cosmetics, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "name", "updated_at"]
  end
end
