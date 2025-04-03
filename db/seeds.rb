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

# Clear existing data
User.destroy_all
Recipe.destroy_all
Review.destroy_all

# Create 20 fake users
20.times do
  User.create!(
    username: Faker::Internet.unique.username,
    email: Faker::Internet.unique.email
  )
end

# Fetch 100 recipes from Edamam API (in batches of 20)
recipes_data = []
5.times do |i|
  edamam_response = HTTParty.get(
    "https://api.edamam.com/search",
    query: {
      q: ["pasta", "chicken", "vegetarian", "dessert", "soup"][i],
      app_id: ENV['EDAMAM_APP_ID'],
      app_key: ENV['EDAMAM_APP_KEY'],
      from: 0,
      to: 20
    }
  )
  recipes_data.concat(JSON.parse(edamam_response.body)["hits"])
end

# Store recipes
recipes_data.each do |hit|
  recipe_data = hit["recipe"]

  Recipe.create!(
    title: recipe_data["label"],
    cooking_time: rand(10..60),
    ingredients_list: recipe_data["ingredients"].map { |i| i["food"] }.join(','),
    dietary_labels: recipe_data["healthLabels"].join(','),
    image_url: recipe_data["image"]
  )
end

# Create 2-3 reviews per recipe (some marked as favorites)
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

puts "Created #{User.count} users"
puts "Created #{Recipe.count} recipes"
puts "Created #{Review.count} reviews (#{Review.where(is_favorite: true).count} favorites)"