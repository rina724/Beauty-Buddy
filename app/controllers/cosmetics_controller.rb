class CosmeticsController < ApplicationController
  before_action :authenticate_user!

  def index
    @cosmetics = Cosmetic.includes(:category, :brand)
  end
end
