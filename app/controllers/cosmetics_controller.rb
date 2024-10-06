class CosmeticsController < ApplicationController
  before_action :authenticate_user!

  def index
    @q = Cosmetic.ransack(params[:q])
    @cosmetics = @q.result(distinct: true).includes(:category, :brand)
    @categories = Category.all
    @user_mycosmetics = current_user.mycosmetics.pluck(:cosmetic_id)
  end

  def show
    @cosmetic = Cosmetic.find(params[:id])
    @mycosmetic = current_user.mycosmetics.find_by(cosmetic_id: @cosmetic.id)
  end
end
