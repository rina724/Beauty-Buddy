# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [ :create ]
  before_action :configure_account_update_params, only: [ :update ]

  # GET /resource/sign_up
  def new
    @user = User.new
  end

  # POST /resource
  def create
    @user = User.new(sign_up_params)
    if @user.save
      sign_in(@user) # ユーザーをサインインさせる
      redirect_to cosmetics_path # コスメ一覧ページにリダイレクト
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    @user = current_user
    if @user.update(account_update_params)
      redirect_to user_path(@user)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # パスワード変更なしでユーザー情報を編集可能にする
  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  # 更新後にマイページへリダイレクト
  def after_update_path_for(resource)
    user_path(current_user)
  end

  # サインアップ時のストロングパラメータを追加（デフォルトに加えて）
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name])
  end

  # アカウント編集時のストロングパラメータを追加（デフォルトに加えて）
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name avatar avatar_cache])
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   cosmetics_path
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
