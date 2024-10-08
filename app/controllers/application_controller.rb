class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  add_flash_types :success, :danger
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :avatar ])
  end

  private

  # ログイン後のリダイレクト先
  def after_sign_in_path_for(resource_or_scope)
    # ここを好きなパスに変更
    cosmetics_path
  end

  # ログアウト後のリダイレクト先
  def after_sign_out_path_for(resource_or_scope)
    # ここを好きなパスに変更
    new_user_session_path
  end
end
