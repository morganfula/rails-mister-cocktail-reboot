# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# require 'open-uri'

# puts "Destroy ingredients"
# Ingredient.destroy_all if Rails.env.development?

# puts "Destroy Cocktails"
# Cocktail.destroy_all if Rails.env.development?

# puts "Create ingredients"
# url = "https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list"
# ingredients = JSON.parse(open(url).read)
# ingredients["drinks"].each do |ingredient|
#   i = Ingredient.create!(name: ingredient["strIngredient1"])
#   puts "create #{i.name}"
# end

require "json"
require "open-uri"

# puts "Cleaning database..."
# Ingredient.destroy_all
# puts "Creating ingredients..."
# INGREDIENTS_URL = "https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list"
# result = JSON.parse(open(INGREDIENTS_URL).read)

# result["drinks"].each do |data|
#   new_ingredient = Ingredient.new(name: data["strIngredient1"])
#   new_ingredient.save!
# end
# puts "Finished with the ingredients creation!"


puts "Cleaning database..."
Cocktail.destroy_all
puts "Creating cocktails..."
COCKTAILS_URL = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=gin"
result = JSON.parse(open(COCKTAILS_URL).read)

result["drinks"].each do |data|
  new_cocktail = Cocktail.new(name: data["strDrink"],
    img_url: data["strDrinkThumb"])
  new_cocktail.save!

  i = 1
  until i > 15 do
    ingredient_id = Ingredient.find_by(name: data["strIngredient#{i}"])&.id
    if ingredient_id.present?
      dose = Dose.new(description: data["strMeasure#{i}"],
        cocktail_id: new_cocktail.id,
        ingredient_id: ingredient_id
      )
      dose.save
    end

    i += 1
  end

end
puts "Finished!"