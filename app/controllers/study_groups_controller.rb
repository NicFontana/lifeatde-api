class StudyGroupsController < ApplicationController
	include Pagination
  before_action :set_study_group, only: [:update, :destroy]

	# GET /course/:course_id/study_groups
  def index
	  course = Course.find(params[:course_id])
	  @pagy, @study_groups= pagy(course.study_groups.includes(:user, :course).order(created_at: :desc))

	  @serializer_options[:include] = [:user, :course]
	  @serializer_options.merge!(pagination_options(@pagy))

	  render json: StudyGroupSerializer.new(@study_groups, @serializer_options).serialized_json
  end

  # GET /study_groups/1
  def show
    @study_group = StudyGroup.includes(:user, :course).find(params[:id])

    @serializer_options[:include] = [:user, :course]

    render json: StudyGroupSerializer.new(@study_group, @serializer_options).serialized_json
  end

  # POST /course/:course_id/study_groups
  def create
	  course = Course.find(params[:course_id])

    @study_group = StudyGroup.new(study_group_params)
    @study_group.user = auth_user
    @study_group.course = course

    if @study_group.save
	    @serializer_options[:include] = [:user, :course]

      render json: StudyGroupSerializer.new(@study_group, @serializer_options).serialized_json, status: :created
    else
      render json: ErrorSerializer.new(@study_group.errors, Rack::Utils.status_code(:unprocessable_entity)).serialized_json, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /study_groups/1
  def update
	  if @study_group.user.id == auth_user.id
	    if @study_group.update(study_group_params)
		    @serializer_options[:include] = [:user, :course]

	      render json: StudyGroupSerializer.new(@study_group, @serializer_options).serialized_json
	    else
	      render json: ErrorSerializer.new(@study_group.errors, Rack::Utils.status_code(:unprocessable_entity)).serialized_json, status: :unprocessable_entity
	    end
	  else
		  render json: ErrorSerializer.new('You cannot update a study group that is not your', Rack::Utils.status_code(:forbidden)).serialized_json, status: :forbidden
	  end
  end

  # DELETE /study_groups/1
  def destroy
	  if @study_group.user.id == auth_user.id
		  @study_group.destroy

			render json: SuccessSerializer.new('Study group deleted successfully!', Rack::Utils.status_code(:ok)).serialized_json
	  else
		  render json: ErrorSerializer.new('You cannot delete a study group that is not your', Rack::Utils.status_code(:forbidden)).serialized_json, status: :forbidden
	  end
  end

	def search
		if params[:search].present?
			@pagy, @study_groups = pagy(StudyGroup.matching(params[:search]).includes(:user, :course).order(created_at: :desc))
		else
			@pagy, @study_groups = pagy(StudyGroup.includes(:user, :course).order(created_at: :desc))
		end

		@serializer_options[:include] = [:user, :course]
		@serializer_options.merge!(pagination_options(@pagy))
		render json: StudyGroupSerializer.new(@study_groups, @serializer_options).serialized_json
	end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_study_group
      @study_group = StudyGroup.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def study_group_params
      params.require(:study_group).permit(:title, :description, :course_id)
    end
end
