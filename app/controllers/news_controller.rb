class NewsController < ApplicationController
  include Pagination
  before_action :set_news, only: [:show]

  #GET /courses/:course_id/news
  def index
    course = Course.find(params[:course_id])
    @pagy, @news = pagy(course.news.order(created_at: :desc))

    render json: NewsSerializer.new(@news, pagination_options(@pagy)).serialized_json
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
