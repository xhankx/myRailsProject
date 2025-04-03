class PagesController < ApplicationController
  def about
  end

  def home
  end

  def recipes
    @recipes = if params[:search].present?
      Recipe.where("title LIKE :search OR ingredients_list LIKE :search OR dietary_labels LIKE :search",
                  search: "%#{params[:search]}%")
            .page(params[:page])
            .per(9)
    else
      Recipe.page(params[:page]).per(9)
    end
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
