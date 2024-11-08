class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[line]

  has_many :mycosmetics, dependent: :destroy
  has_one :profile
  has_many :daily_reports
  has_many :cosmetics
  has_many :favorites
  has_many :favorite_cosmetics, through: :favorites, source: :cosmetic
  mount_uploader :avatar, AvatarUploader

  def social_profile(provider)
    social_profiles.select { |sp| sp.provider == provider.to_s }.first
  end

  def set_values(omniauth)
    return if provider.to_s != omniauth["provider"].to_s || uid != omniauth["uid"]
    credentials = omniauth["credentials"]
    info = omniauth["info"]

    access_token = credentials["refresh_token"]
    access_secret = credentials["secret"]
    credentials = credentials.to_json
    name = info["name"]
    # self.set_values_by_raw_info(omniauth['extra']['raw_info'])
  end

  def set_values_by_raw_info(raw_info)
    self.raw_info = raw_info.to_json
    self.save!
  end


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
