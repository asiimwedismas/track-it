class ItemsController < ApplicationController
  before_action :set_category
  before_action :set_category_item, only: %i[show update destroy]

  # GET /categories/:category_id/items
  def index
    json_response(Item.where(user_id: current_user.id, category_id: params[:category_id]))
  end

  # GET /categories/:category_id/items/:id
  def show
    json_response(@item)
  end

  # POST /categories/:category_id/items
  def create
    @category.items.create!(name: params[:name], amount: params[:amount], user_id: current_user.id)
    json_response(@category, :created)
  end

  # PUT /categories/:category_id/items/:id
  def update
    @item.update(item_params)
    json_response(@item, :ok)
  end

  # DELETE /categories/:category_id/items/:id
  def destroy
    @item.destroy
    json_response(@item, :ok)
  end

  private

  def item_params
    params.permit(:name, :amount)
  end

  def set_category
    @category = Category.find(params[:category_id])
  end

  def set_category_item
    @item = @category.items.find_by!(id: params[:id]) if @category
  end
end
