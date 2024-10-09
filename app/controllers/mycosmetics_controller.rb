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
      redirect_to mycosmetics_path, success: "マイコスメに登録できました"
    else
      flash.now[danger] = "すでに登録されています"
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @q = Mycosmetic.includes(cosmetic: [ :category, :brand ]).ransack(params[:q])
    @mycosmetics = @q.result(distinct: true).where(user: current_user).page(params[:page])
  end

  def edit
    @mycosmetic = current_user.mycosmetics.find(params[:id])
    @cosmetic = Cosmetic.find(@mycosmetic.cosmetic_id)
  end

  def update
    @mycosmetic = current_user.mycosmetics.find(params[:id])
    @cosmetic = Cosmetic.find(@mycosmetic.cosmetic_id)
    if @mycosmetic.update(mycosmetic_params)
      redirect_to mycosmetics_path, success: "登録内容を更新しました"
    else
      flash.now[danger] = "登録内容の更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @mycosmetic = current_user.mycosmetics.find(params[:id])
    @mycosmetic.destroy!
    redirect_to mycosmetics_path, success: "マイコスメから削除しました"
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
end
