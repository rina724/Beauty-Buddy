class CosmeticsController < ApplicationController
  before_action :authenticate_user!

  def index
    @cosmetics = Cosmetic.includes(:category, :brand)
  end

  def show
    @cosmetic = Cosmetic.find(params[:id])
  end
end
