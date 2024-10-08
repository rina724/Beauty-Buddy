class CosmeticsController < ApplicationController
  before_action :authenticate_user!

  def index
    @q = Cosmetic.ransack(params[:q])
    @cosmetics = @q.result(distinct: true).includes(:category, :brand)
    @user_mycosmetics = current_user.mycosmetics.pluck(:cosmetic_id)
  end

  def show
    @cosmetic = Cosmetic.find(params[:id])
    @mycosmetic = current_user.mycosmetics.find_by(cosmetic_id: @cosmetic.id)
  end

  def search
    @cosmetics = Cosmetic.where("product_name like ?", "%#{params[:q]}%")
    @brands = Brand.where("name like ?", "%#{params[:q]}%")
      respond_to do |format|
        format.js
      end
  end
end
