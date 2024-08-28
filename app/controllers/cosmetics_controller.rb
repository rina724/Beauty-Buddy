class CosmeticsController < ApplicationController
  def index
    @cosmetics = Cosmetic.includes(:category, :brand)
  end
end
