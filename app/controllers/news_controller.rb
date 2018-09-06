class NewsController < ApplicationController
  include Pagination
  before_action :set_news, only: [:show]

  #GET /courses/:course_id/news
  def course_news
    @pagy, @news = pagy(News.course_news(params[:course_id]).order(created_at: :desc))
    render json: NewsSerializer.new(@news, pagination_options).serialized_json
  end

  # GET /courses/:course_id/news/:id
  def show
    render json: NewsSerializer.new(@news).serialized_json
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_news
      @news = News.find(params[:id])
    end
end
