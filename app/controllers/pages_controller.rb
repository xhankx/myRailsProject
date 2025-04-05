# ------------------------------------------------------------------
#
#    WEBD-3011 (263714) Agile Full Stack Web Development
#    Name: Hang Xu
#    Date: 2025-04-05
#    Description: Rails Intro Project
#
# ------------------------------------------------------------------

class PagesController < ApplicationController
  def about
  end

  def home
  end

  def recipes
    @recipes = Recipe.all

    # Apply category filter if selected
    if params[:category].present?
      @recipes = @recipes.where("dietary_labels LIKE ?", "%#{params[:category]}%")
    end

    # Apply search filter if present
    if params[:search].present?
      @recipes = @recipes.where("title LIKE :search OR ingredients_list LIKE :search OR dietary_labels LIKE :search",
                              search: "%#{params[:search]}%")
    end

    # Apply pagination
    @recipes = @recipes.page(params[:page]).per(9)

    # Get all categories for the dropdown
    @categories = ['Beef', 'Chicken', 'Dessert', 'Lamb', 'Miscellaneous', 'Pasta',
                  'Pork', 'Seafood', 'Side', 'Starter', 'Vegan', 'Vegetarian',
                  'Breakfast', 'Goat']
  end

  def recipe
    @recipe = Recipe.find(params[:id])
    @reviews = @recipe.reviews.includes(:user)
  end

  def category
    @category = params[:category]
    @recipes = Recipe.where("dietary_labels LIKE ?", "%#{@category}%")
                    .page(params[:page])
                    .per(9)
  end
end
