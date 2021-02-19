class Admin::CategoriesController < ApplicationController
  before_action :require_admin
  before_action :set_category, only: %i[update destroy]

  # GET /categories
  def index
    @categories = Category.all
    json_response(@categories)
  end

  # POST /categories
  def create
    @category = Category.create!(category_params)
    json_response(@category, :created)
  end

  # PUT /categories/:id
  def update
    @category.update(category_params)
    json_response(@category, :ok)
  end

  # DELETE /categories/:id
  def destroy
    @category.destroy
    json_response(@category, :ok)
  end

  private

  def category_params
    params.permit(:title)
  end

  def set_category
    @category = Category.find(params[:id])
  end
end
