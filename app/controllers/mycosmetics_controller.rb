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
      redirect_to cosmetics_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def mycosmetic_params
    params.require(:mycosmetic).permit(:usage_situation, :starting_date, :problem, :memo, :cosmetic_id).merge(user_id: params[:user_id])
  end
end
