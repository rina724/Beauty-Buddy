class FavoritesController < ApplicationController
  def create
    @cosmetic = Cosmetic.find(params[:cosmetic_id])
    current_user.favorite(@cosmetic)
  end

  def destroy
    @cosmetic = Cosmetic.find(params[:cosmetic_id])
    current_user.unfavorite(@cosmetic)
  end
end
