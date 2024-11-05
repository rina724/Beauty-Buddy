class ProfilesController < ApplicationController
  def index
    @user = current_user
    @current_user_profile = @user.profile || @user.build_profile

    # バッド評価のマイコスメを取得
    @user_bad_mycosmetics = Mycosmetic.joins(:cosmetic)
                                      .where(mycosmetics: { problem: 2 }, user_id: @user.id)

    # 成分のカウントと頻出成分の取得
    @ingredient_counts = count_ingredients
    @caution_ingredients = get_frequent_ingredients

    # 選択済みの成分IDを取得
    @selected_ingredient_ids = @current_user_profile.ingredients.pluck(:id)
  end

  def update_allergy
    @user = current_user
    @current_user_profile = Profile.find(params[:id])
    if @current_user_profile.update(profile_params)
      redirect_to profiles_path
    else
      render :update, status: :unprocessable_entity
    end
  end

  def update
    @user = current_user
    @current_user_profile = @user.profile
    @ingredient_counts = count_ingredients
    @caution_ingredients = get_frequent_ingredients
    
    if update_ingredients
      # 成分の関連付けを更新

      redirect_to profiles_path, success: t("profiles.update.success")
    else
      @ingredient_counts = count_ingredients
      @caution_ingredients = get_frequent_ingredients
      render :index, status: :unprocessable_entity
    end
  end

  private

  def update_ingredients
    # 現在の関連をすべて削除
    @current_user_profile.profiles_ingredients.destroy_all

    # 選択された成分の関連を作成
    if params[:ingredient_ids].present? && params[:ingredient_ids].any?
      params[:ingredient_ids].reject(&:blank?).each do |ingredient_id|
        @current_user_profile.profiles_ingredients.create!(
          ingredient_id: ingredient_id
        )
      end
    else
      # 何も選択されていない場合、関連を空にしない
      true
    end
  end

  def count_ingredients
    return Hash.new(0) if @user_bad_mycosmetics.nil?

    counts = Hash.new(0)
    @user_bad_mycosmetics.each do |mycosmetic|
      mycosmetic.cosmetic.ingredients.each do |ingredient|
        counts[ingredient] += 1
      end
    end
    counts
  end

  def get_frequent_ingredients
    return [] if @ingredient_counts.empty?

    # 出現回数が2回以上の成分を抽出
    threshold = 2

    Ingredient.where(id: @ingredient_counts.select { |ingredient, count|
      count >= threshold }.keys.map(&:id))
  end

  def profile_params
    params.require(:profile).permit(:allergy)
  end
end
