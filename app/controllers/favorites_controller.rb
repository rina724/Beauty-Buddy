class FavoritesController < ApplicationController
  def create
    @cosmetic = Cosmetic.find(params[:cosmetic_id])
    current_user.favorite(@cosmetic)
    redirect_to request.referer
  end

  def destroy
    @cosmetic = Cosmetic.find(params[:cosmetic_id])
    current_user.unfavorite(@cosmetic)
    redirect_to request.referer, status: :see_other
  end
end
