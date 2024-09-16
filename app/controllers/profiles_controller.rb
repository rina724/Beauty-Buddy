class ProfilesController < ApplicationController
  def index
    @user = current_user
    @profile = @user.profile || Profile.new(user: @user)
    @allergies = Profile.includes(:user)
    
    # Get bad mycosmetics for the user
    @user_bad_mycosmetics = Mycosmetic.joins(:cosmetic).where(mycosmetics: { problem: 2 }, user_id: @user.id)
    
    # Count ingredients
    ingredient_count = Hash.new(0)
    
    @user_bad_mycosmetics.each do |my_cosmetic|
      cosmetic = my_cosmetic.cosmetic
      ingredients = cosmetic.ingredient.split(',')
      
      ingredients.each do |ingredient|
        ingredient_count[ingredient.strip] += 1
      end
    end
    
    # Set caution ingredients (5 times or more)
    @caution_ingredients = ingredient_count.select { |_, count| count >= 3 }.keys
    @profile.save
    # Update profile with caution ingredients
    if @profile.update(caution: @caution_ingredients.join(', '))
      flash[:notice] = "Caution ingredients updated successfully."
    else
      flash[:alert] = "Failed to update caution ingredients."
    end
    
    # Render the view
    render :index
  end

  private

  def profile_params
    params.require(:profile).permit(:caution, :allergy)
  end
end