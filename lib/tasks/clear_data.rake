namespace :db do
  desc "Clear all data from specified tables"
  task clear_data: :environment do
    Cosmetic.delete_all
    Mycosmetic.delete_all
    Favorite.delete_all
    Brand.delete_all
    Category.delete_all
    puts "All specified data has been deleted."
  end
end