class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :update, :destroy]

  # GET /projects
  def index
    begin
      @projects = Project.user_related_projects(auth_user).order(created_at: :desc)
    rescue ActiveRecord::RecordNotFound => e
      render json: ErrorSerializer.new(e.message, Rack::Utils.status_code(:not_found)).serialized_json, status: :not_found
    end
    @pagy = pagy(@projects)
    render json: ProjectSerializer.new(@projects, pagination_options).serialized_json
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

  # GET /category/category_id/projects
  def category_projects
    begin
      @projects = Project.category_projects(params[:category_id]).order(created_at: :desc)
    rescue ActiveRecord::RecordNotFound => e
      render json: ErrorSerializer.new(e.message, Rack::Utils.status_code(:not_found)).serialized_json, status: :not_found
    end
    @pagy = pagy(@projects)
    render json: ProjectSerializer.new(@projects, pagination_options).serialized_json
  end

  # GET /user/user_id/projects
  def user_projects
    begin
      @projects = Project.user_projects(params[:user_id]).order(created_at: :desc)
    rescue ActiveRecord::RecordNotFound => e
      render json: ErrorSerializer.new(e.message, Rack::Utils.status_code(:not_found)).serialized_json, status: :not_found
    end
    @pagy = pagy(@projects)
    render json: ProjectSerializer.new(@projects, pagination_options).serialized_json
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      begin
        @project = Project.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        render json: ErrorSerializer.new(e.message, Rack::Utils.status_code(:not_found)).serialized_json, status: :not_found
      end
    end

    # Only allow a trusted parameter "white list" through.
    def project_params
      params.require(:project).permit(:title, :description, :results, :status_id)
    end
end
