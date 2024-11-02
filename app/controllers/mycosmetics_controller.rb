class MycosmeticsController < ApplicationController
  before_action :authenticate_user!

  def new
    @cosmetic = Cosmetic.find(params[:cosmetic_id]) # cosmetic_idを使ってCosmeticを取得
    @mycosmetic = Mycosmetic.new # 新しいMycosmeticのインスタンスを生成
  end

  def create
    @cosmetic = Cosmetic.find(params[:mycosmetic][:cosmetic_id]) # フォームから送信されたcosmetic_idを使ってCosmeticを取得
    @mycosmetic = current_user.mycosmetics.build(mycosmetic_params) # Mycosmeticをユーザーに紐付けてインスタンス生成
    if @mycosmetic.save
      redirect_to mycosmetics_path, success: t("defaults.flash_message.created", item: Mycosmetic.model_name.human)
    else
      flash.now[danger] = t("defaults.flash_message.alreadly_registered")
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @user = current_user
    @q = Mycosmetic.includes(cosmetic: [ :category, :brand ]).ransack(params[:q])
    @mycosmetics = @q.result(distinct: true).where(user: current_user).page(params[:page])
    @profile = @user.profile

    # 表示が有効な注意成分を取得
    @warning_ingredients = get_active_warning_ingredients
  end

  def edit
    @mycosmetic = current_user.mycosmetics.find(params[:id])
    @cosmetic = Cosmetic.find(@mycosmetic.cosmetic_id)
  end

  def update
    @mycosmetic = current_user.mycosmetics.find(params[:id])
    @cosmetic = Cosmetic.find(@mycosmetic.cosmetic_id)
    if @mycosmetic.update(mycosmetic_params)
      redirect_to mycosmetics_path, success: t("mycosmetics.update.success")
    else
      flash.now[danger] = t("mycosmetics.update.failure")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @mycosmetic = current_user.mycosmetics.find(params[:id])
    @mycosmetic.destroy!
    redirect_to mycosmetics_path, success: t("defaults.flash_message.destroyed", item: Mycosmetic.model_name.human)
  end

  def search
    query = params[:q]
    @mycosmetics = current_user.mycosmetics.joins(:cosmetic)
                            .where("cosmetics.product_name ILIKE ?", "%#{query}%") # クエリによるフィルタリング
                            .includes(cosmetic: :brand)

    brand_ids = current_user.mycosmetics
                            .joins(cosmetic: :brand)
                            .where("brands.name ILIKE ?", "%#{query}%")
                            .pluck("brands.id")
                            .uniq

    @brands = Brand.where(id: brand_ids)

      respond_to do |format|
        format.js
      end
  end

  private

  def mycosmetic_params
    params.require(:mycosmetic).permit(:usage_situation, :starting_date, :problem, :memo, :cosmetic_id, :user_id)
  end

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
