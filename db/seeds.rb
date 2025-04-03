# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'faker'
require 'httparty'
require 'json'

puts "Starting seeding process..."

# Clear existing data
puts "Clearing existing data..."
User.destroy_all
Recipe.destroy_all
Review.destroy_all
puts "Existing data cleared."

# Create 20 fake users
puts "Creating users..."
20.times do
  User.create!(
    username: Faker::Internet.unique.username,
    email: Faker::Internet.unique.email
  )
end
puts "Created #{User.count} users"

# Fetch recipes from TheMealDB API
puts "Fetching recipes from TheMealDB API..."
recipes_data = []
categories = ['Beef', 'Chicken', 'Dessert', 'Lamb', 'Miscellaneous', 'Pasta', 'Pork', 'Seafood', 'Side', 'Starter', 'Vegan', 'Vegetarian', 'Breakfast', 'Goat']

categories.each do |category|
  puts "Fetching #{category} recipes..."
  response = HTTParty.get("https://www.themealdb.com/api/json/v1/1/filter.php?c=#{category}")
  if response.success? && response.body != "{\"meals\":null}"
    meals = JSON.parse(response.body)["meals"]
    puts "Found #{meals.length} #{category} recipes"
    meals.each do |meal|
      # Get detailed recipe information
      detail_response = HTTParty.get("https://www.themealdb.com/api/json/v1/1/lookup.php?i=#{meal['idMeal']}")
      if detail_response.success?
        recipe_detail = JSON.parse(detail_response.body)["meals"][0]

        # Extract ingredients and measurements
        ingredients = []
        (1..20).each do |i|
          ingredient = recipe_detail["strIngredient#{i}"]
          measure = recipe_detail["strMeasure#{i}"]
          ingredients << "#{measure} #{ingredient}" if ingredient.present? && ingredient.strip != ""
        end

        Recipe.create!(
          title: recipe_detail["strMeal"],
          cooking_time: rand(10..60), # Random cooking time since API doesn't provide it
          ingredients_list: ingredients.join(", "),
          dietary_labels: [category].join(", "),
          image_url: recipe_detail["strMealThumb"]
        )
      end
    end
  else
    puts "No #{category} recipes found"
  end
end
puts "Created #{Recipe.count} recipes"

# Create 2-3 reviews per recipe (some marked as favorites)
puts "Creating reviews..."
Recipe.all.each do |recipe|
  rand(2..3).times do
    Review.create!(
      user: User.all.sample,
      recipe: recipe,
      rating: rand(1..5),
      comment: Faker::Food.description,
      is_favorite: rand(0..1) == 1  # Randomly mark some as favorites
    )
  end
end
puts "Created #{Review.count} reviews (#{Review.where(is_favorite: true).count} favorites)"

puts "Seeding completed!"

response = HTTParty.get("https://www.themealdb.com/api/json/v1/1/filter.php?c=Beef")
puts response.body