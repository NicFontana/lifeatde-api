class CategoriesController < ApplicationController
  before_action :set_category, only: [:show]

  # GET /categories
  def index
    @categories = Category.all

    render json: CategorySerializer.new(@categories).serialized_json
  end

  # GET /categories/:id
  def show
    render json: CategorySerializer.new(@category).serialized_json
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def category_params
      params.require(:category).permit(:name)
    end
end
