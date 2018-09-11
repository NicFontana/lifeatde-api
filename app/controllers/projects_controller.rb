class ProjectsController < ApplicationController
	include Pagination
  before_action :set_project, only: [:show, :update, :destroy]

  # GET /projects
  def index
    @pagy, @projects = pagy(Project.for_user(auth_user).open.includes(:admin).order(created_at: :desc))

    @serializer_options[:include] = [:admin]
    @serializer_options.merge!(pagination_options(@pagy))
    render json: ProjectSerializer.new(@projects, @serializer_options).serialized_json
  end

  # GET /projects/1
  def show
    render json: ProjectSerializer.new(@project).serialized_json
  end

  # POST /projects
  def create
    @project = Project.new(project_params)

    if @project.save
      render json: ProjectSerializer.new(@project).serialized_json
    else
      render json: ErrorSerializer.new(@project.errors, Rack::Utils.status_code(:unprocessable_entity)).serialized_json, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(project_params)
      render json: ProjectSerializer.new(@project).serialized_json
    else
      render json: ErrorSerializer.new(@project.errors, Rack::Utils.status_code(:unprocessable_entity)).serialized_json, status: :unprocessable_entity
    end
  end

  # DELETE /projects/1
  def destroy
    @project.destroy
  end

  # GET /projects?search=querystring
  def search
    @pagy, @projects = pagy(Project.by_querystring(params[:search]).order(created_at: :desc))

    render json: ProjectSerializer.new(@projects, pagination_options(@pagy)).serialized_json
  end

  # GET /category/category_id/projects
  def category_projects
    @pagy, @projects= pagy(Project.by_category(params[:category_id]).order(created_at: :desc))

    render json: ProjectSerializer.new(@projects, pagination_options(@pagy)).serialized_json
  end

  # GET /user/user_id/projects?admin=1\0
  def user_projects
    user_id = params[:user_id]
	  if params[:admin].present?
      admin = params[:admin]
      if admin
        @pagy, @projects = pagy(User.find(user_id).created_projects.includes(:projects_users, :project_status).order(created_at: :desc))
      else
        @pagy, @projects = pagy(User.find(user_id).joined_projects.includes(:projects_users, :project_status).order(created_at: :desc))
      end
	  else
      @pagy, @projects =pagy(User.find(user_id).all_projects.includes(:projects_users, :project_status).order(created_at: :desc))
    end

    @serializer_options[:params] = { user_id: user_id }
    @serializer_options.merge!(pagination_options(@pagy))

    render json: ProjectSerializer.new(@projects, @serializer_options).serialized_json
  end

  # GET /user/user_id/projects/open
  def user_open_projects
    user_id = params[:user_id]
    @pagy, @projects = pagy(User.find(user_id).all_projects.open.includes(:projects_users).order(created_at: :desc))

    @serializer_options[:params] = {user_id: user_id }
    @serializer_options.merge!(pagination_options(@pagy))
    render json: ProjectSerializer.new(@projects, @serializer_options).serialized_json
  end

  # GET /user/user_id/projects/closed
  def user_closed_projects
    user_id = params[:user_id]
    @pagy, @projects = pagy(User.find(user_id).all_projects.closed.includes(:projects_users).order(created_at: :desc))

    @serializer_options[:params] = {user_id: user_id }
    @serializer_options.merge!(pagination_options(@pagy))
    render json: ProjectSerializer.new(@projects, @serializer_options).serialized_json
  end

  # GET /user/user_id/projects/terminated
  def user_terminated_projects
    user_id = params[:user_id]
    @pagy, @projects = pagy(User.find(user_id).all_projects.terminated.includes(:projects_users).order(created_at: :desc))

    @serializer_options[:params] = {user_id: user_id }
    @serializer_options.merge!(pagination_options(@pagy))
    render json: ProjectSerializer.new(@projects, @serializer_options).serialized_json
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
	    @project = Project.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def project_params
      params.require(:project).permit(:title, :description, :results, :status_id, :admin)
    end
end
