class StudyGroupsController < ApplicationController
	include Pagination
  before_action :set_study_group, only: [:show, :update, :destroy]

  # GET /study_groups
  def index
    @pagy, @study_groups = pagy(StudyGroup.includes(:user).order(created_at: :desc))

    @serializer_options[:include] = [:user]
    @serializer_options.merge!(pagination_options(@pagy))

    render json: StudyGroupSerializer.new(@study_groups, @serializer_options).serialized_json
  end

  # GET /study_groups/1
  def show
    render json: @study_group
  end

  # POST /study_groups
  def create
    @study_group = StudyGroup.new(study_group_params)

    if @study_group.save
      render json: @study_group, status: :created, location: @study_group
    else
      render json: @study_group.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /study_groups/1
  def update
    if @study_group.update(study_group_params)
      render json: @study_group
    else
      render json: @study_group.errors, status: :unprocessable_entity
    end
  end

  # DELETE /study_groups/1
  def destroy
    @study_group.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_study_group
      @study_group = StudyGroup.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def study_group_params
      params.require(:study_group).permit(:title, :description, :user_id, :course_id)
    end
end
