class StudyGroupsController < ApplicationController
	include Pagination
  before_action :set_study_group, only: [:update, :destroy]

	# GET /course/:course_id/study_groups
  def index
	  @pagy, @study_groups = pagy(Course.find(params[:course_id]).study_groups.includes(:user, user: [:avatar_attachment]).order(created_at: :desc))

	  @serializer_options[:include] = [:user]
	  @serializer_options.merge!(pagination_options(@pagy))

	  render json: StudyGroupSerializer.new(@study_groups, @serializer_options).serialized_json
  end

  # GET /study_groups/:id
  def show
    @study_group = StudyGroup.includes(:user, :course, user: [:avatar_attachment]).find(params[:id])

    @serializer_options[:include] = [:user]

    render json: StudyGroupSerializer.new(@study_group, @serializer_options).serialized_json
  end

  # POST /course/:course_id/study_groups
  def create
    @study_group = StudyGroup.new(study_group_params)
    @study_group.user = auth_user
    @study_group.course = Course.find(params[:course_id])

    if @study_group.save
	    @serializer_options[:include] = [:user]
	    @serializer_options[:meta][:messages] = ['Gruppo di studio creato con successo!']

      render json: StudyGroupSerializer.new(@study_group, @serializer_options).serialized_json, status: :created
    else
      render json: ErrorSerializer.new(@study_group.errors, status_code(:unprocessable_entity)).serialized_json, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /study_groups/:id
  def update
	  unless @study_group.user.id == auth_user.id
		  return render json: ErrorSerializer.new('Non puoi aggiornare il gruppo di studio se non sei l\'admin', status_code(:forbidden)).serialized_json, status: :forbidden
	  end

    if @study_group.update(study_group_params)
	    @serializer_options[:meta][:messages] = ['Gruppo di studio aggiornato con successo!']

      render json: StudyGroupSerializer.new(@study_group, @serializer_options).serialized_json
    else
      render json: ErrorSerializer.new(@study_group.errors, status_code(:unprocessable_entity)).serialized_json, status: :unprocessable_entity
    end
  end

  # DELETE /study_groups/:id
  def destroy
	  @user = auth_user
	  unless @study_group.user.id == @user.id
		  return render json: ErrorSerializer.new('Non puoi eliminare il gruppo di studio se non sei l\'admin', status_code(:forbidden)).serialized_json, status: :forbidden
	  end

	  @study_group.destroy

	  @serializer_options[:meta][:messages] = ['Gruppo di studio eliminato con successo!']

	  render json: StudyGroupSerializer.new(@study_group, @serializer_options).serialized_json
  end

	def search
		if params[:search].present?
			@pagy, @study_groups = pagy(StudyGroup.matching(params[:search]).includes(:user, :course, user: [:avatar_attachment]).order(created_at: :desc))
		else
			@pagy, @study_groups = pagy(StudyGroup.includes(:user, :course, user: [:avatar_attachment]).order(created_at: :desc))
		end

		@serializer_options[:include] = [:user]
		@serializer_options.merge!(pagination_options(@pagy))

		render json: StudyGroupSerializer.new(@study_groups, @serializer_options).serialized_json
	end

	# GET /users/:user_id/study_groups
	def user_study_groups
		@pagy, @study_groups = pagy(User.with_attached_avatar.find(params[:user_id]).study_groups.includes(:course).order(created_at: :desc))

		@serializer_options[:include] = [:user]
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
