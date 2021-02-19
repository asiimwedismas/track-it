class CategoriesController < ApplicationController
  before_action :set_category, only: %i[show update destroy]

  # GET /categories
  def index
    @categories = Category.all
    json_response(@categories)
  end

  # GET /categories/:id
  def show
    json_response(@category)
  end

  private

  def category_params
    params.permit(:title)
  end

  def set_category
    @category = Category.find(params[:id])
  end
end
