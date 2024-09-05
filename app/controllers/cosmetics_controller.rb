class CosmeticsController < ApplicationController
  before_action :authenticate_user!

  def index
    @cosmetics = Cosmetic.includes(:category, :brand)
  end

  def show
    @cosmetic = Cosmetic.find(params[:id])
    @mycosmetic = current_user.mycosmetics.find(params[:id])
  end
end
