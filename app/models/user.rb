class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         :omniauthable, omniauth_providers: %i[line]

  has_many :mycosmetics, dependent: :destroy
  has_one :profile
  has_many :daily_reports
  has_many :cosmetics
  has_many :favorites
  has_many :favorite_cosmetics, through: :favorites, source: :cosmetic
  mount_uploader :avatar, AvatarUploader


  def favorite(cosmetic)
    favorite_cosmetics << cosmetic
  end

  def unfavorite(cosmetic)
    favorite_cosmetics.destroy(cosmetic)
  end

  def favorite?(cosmetic)
    favorite_cosmetics.include?(cosmetic)
  end
end
