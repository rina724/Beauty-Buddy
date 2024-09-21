class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :mycosmetics, dependent: :destroy
  has_one :profile
  has_many :favorites
  has_many :cosmetics, through: :favorites
  mount_uploader :avatar, AvatarUploader
end
