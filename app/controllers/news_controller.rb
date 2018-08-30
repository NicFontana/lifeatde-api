class NewsController < ApplicationController
  include Pagination
  before_action :set_news, only: [:show, :update, :destroy]

  # GET /news
  def index
    @pagy, @news = pagy(News.order(created_at: :desc))

    render json: NewsSerializer.new(@news, pagination_options).serialized_json
  end

  # GET /news/1
  def show
    render json: NewsSerializer.new(@news).serialized_json
  end

  # -ROUTE-> GET ?
  #retrieving the news for the course of the logged user
  def get_news_for_user
    @course = get_auth_user.course
    @pagy, @news = pagy(News.where(course: @course))

    render json: NewsSerializer.new(@news, pagination_options).serialized_json
  end

  # -ROUTE-> GET ?
  #retrieving the news for a course
  def get_news_for_course
    @course = Course.find_by(params[:course_id])
    @pagy, @news = pagy(News.where(course: @course))

    render json: NewsSerializer.new(@news, pagination_options).serialized_json
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_news
      @news = News.find(params[:id])
    end
end
