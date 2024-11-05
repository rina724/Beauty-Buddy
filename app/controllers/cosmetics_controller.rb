class CosmeticsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @q = Cosmetic.ransack(params[:q])
    @cosmetics = @q.result(distinct: true).includes(:category, :brand).page(params[:page])
    @user_mycosmetics = current_user.mycosmetics.pluck(:cosmetic_id)
    @profile = @user.profile

    # 表示が有効な注意成分を取得
    @warning_ingredients = get_active_warning_ingredients

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

  private

  def get_active_warning_ingredients
    return [] unless @profile

    # チェックされている（表示が有効な）注意成分を取得
    checked_caution_ingredients = @profile.ingredients.pluck(:name)

    # アレルギー成分を配列として取得
    allergy_ingredients = @profile.allergy&.split(",")&.map(&:strip) || []

    # 両方の配列を結合して重複を除去
    (checked_caution_ingredients + allergy_ingredients).uniq
  end
end
