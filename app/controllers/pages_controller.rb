class PagesController < ApplicationController
  def about
  end

  def home
  end

  def recipes
    @recipes = Recipe.all
  end

  def recipe
    @recipe = Recipe.find(params[:id])
    @reviews = @recipe.reviews.includes(:user)
  end
end
