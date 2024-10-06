class CosmeticsController < ApplicationController
  before_action :authenticate_user!

  def index
    @cosmetics = Cosmetic.includes(:category, :brand)
    @user_mycosmetics = current_user.mycosmetics.pluck(:cosmetic_id)
  end

  def show
    @cosmetic = Cosmetic.find(params[:id])
    @mycosmetic = current_user.mycosmetics.find_by(cosmetic_id: @cosmetic.id)
  end
end
