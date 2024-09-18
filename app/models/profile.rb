class Profile < ApplicationRecord
  belongs_to :mycosmetic, optional: true
  belongs_to :user
end
