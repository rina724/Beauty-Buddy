class ProfilesController < ApplicationController
  def update
    @user = current_user
    @current_user_profile = Profile.find(params[:id])
    if @current_user_profile.update(profile_params)
      redirect_to profiles_path
    else
      render :update, status: :unprocessable_entity
    end
  end

  def index
    @user = current_user
    @current_user_profile = @user.profile || @user.build_profile

    # ユーザーが登録したマイコスメでバッドを選んだものだけ取得
    @user_bad_mycosmetics = Mycosmetic.joins(:cosmetic).where(mycosmetics: { problem: 2 }, user_id: @user.id)

    # 成分をカウントする
    ingredient_count = Hash.new(0)
    @user_bad_mycosmetics.each do |my_cosmetic|
      cosmetic = my_cosmetic.cosmetic
      ingredients = cosmetic.ingredient.split(",")
      ingredients.each do |ingredient|
        ingredient_count[ingredient.strip] += 1
      end
    end

    # ５回重複している成分
    @caution_ingredients = ingredient_count.select { |_, count| count >= 5 }.keys
    # プロフィールの注意する成分を上書き
    @current_user_profile && @current_user_profile.update(caution: @caution_ingredients.join(", "))
  end

  private

  def profile_params
    params.require(:profile).permit(:allergy)
  end
end
