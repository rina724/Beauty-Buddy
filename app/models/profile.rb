class Profile < ApplicationRecord
  belongs_to :mycosmetic
  belongs_to :user
end
