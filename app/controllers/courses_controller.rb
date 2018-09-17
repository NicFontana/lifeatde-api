class CoursesController < ApplicationController
  include Pagination
  before_action :set_course, only: [:index, :show]

  # GET /courses
  def index
    @courses = Course.all

    render json: CourseSerializer.new(@courses).serialized_json
  end

  # GET /courses/1
  def show
    render json: CourseSerializer.new(@courses).serialized_json
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end
end
