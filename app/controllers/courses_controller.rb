class CoursesController < ApplicationController
  include Pagination
  before_action :set_course, only: [:show]

  # GET /courses
  def index
    @courses = Course.all

    render json: @courses
  end

  # GET /courses/1
  def show
    render json: @course
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:course_id])
    end

    # Only allow a trusted parameter "white list" through.
    def course_params
      params.require(:course).permit(:name)
    end
end
