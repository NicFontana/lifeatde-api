class ProjectsController < ApplicationController
	include Pagination
  before_action :set_project, only: [:update, :destroy]

  # GET /projects
  # GET /projects?search=query
  def index
    if params[:search].present?
      @pagy, @projects = pagy(Project.matching(params[:search]).includes(:admins, :project_status, :categories).order(created_at: :desc))
    else
      @pagy, @projects = pagy(Project.for_user(auth_user).open.includes(:admins, :project_status, :categories).order(created_at: :desc))
    end

    @serializer_options[:include] = [:admins]
    @serializer_options.merge!(pagination_options(@pagy))
    render json: ProjectSerializer.new(@projects, @serializer_options).serialized_json
  end

  # GET /projects/1
  def show
    @project = Project.includes(:project_status, :categories, members: [:projects_users]).find(params[:id])
    @serializer_options[:include] = [:members]
    @serializer_options[:params] = { project_id: params[:id] }
    render json: ProjectSerializer.new(@project, @serializer_options).serialized_json
  end

  # POST /projects
  def create
    @categories = Category.find(params[:project][:categories])

    @project = Project.new(project_params)

    @project.projects_users.build(admin: true, user_id: auth_user.id)

    if @project.save
      @project.categories << @categories
      render json: ProjectSerializer.new(@project).serialized_json
    else
      render json: ErrorSerializer.new(@project.errors, Rack::Utils.status_code(:unprocessable_entity)).serialized_json, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/1
  def update
    unless @project.admins.detect{ |admin| admin.id == auth_user.id}
      return render json: ErrorSerializer.new("Solo un amministratore può aggiornare le informazioni del progetto.", Rack::Utils.status_code(:forbidden)).serialized_json, status: :forbidden
    end

    @categories = Category.find(params[:project][:categories])

    if @project.update(project_params)
      @project.categories = @categories

      render json: ProjectSerializer.new(@project).serialized_json
    else
      render json: ErrorSerializer.new(@project.errors, Rack::Utils.status_code(:unprocessable_entity)).serialized_json, status: :unprocessable_entity
    end
  end

  # DELETE /projects/1
  def destroy
    unless @project.admins.detect{ |admin| admin.id == auth_user.id}
      return render json: ErrorSerializer.new("Solo un amministratore può aggiornare le informazioni del progetto.", Rack::Utils.status_code(:forbidden)).serialized_json, status: :forbidden
    end

    @project.destroy
  end

  # GET /category/category_id/projects
  def category_projects
    @pagy, @projects= pagy(Category.find(params[:category_id]).projects.includes(:admins, :project_status).order(created_at: :desc))

    @serializer_options[:include] = [:admins]
    @serializer_options.merge!(pagination_options(@pagy))
    render json: ProjectSerializer.new(@projects, @serializer_options).serialized_json
  end

  # GET /user/user_id/projects?status=&admin=1\0
  def user_projects
    user_id = params[:user_id]
    admin = params[:admin]
    status = params[:status]

    case admin
    when '1'
      @projects = User.find(user_id).created_projects.includes(:projects_users, :project_status, :categories).order(created_at: :desc)
    when '0'
      @projects = User.find(user_id).joined_projects.includes(:projects_users, :project_status, :categories).order(created_at: :desc)
    else
      @projects = User.find(user_id).all_projects.includes(:projects_users, :project_status, :categories).order(created_at: :desc)
    end

    case status
    when 'open'
      @projects = @projects.open
    when 'closed'
      @projects = @projects.closed
    when 'terminated'
      @projects = @projects.terminated
    end

    @pagy, @projects = pagy(@projects)
    @serializer_options[:params] = { user_id: user_id }
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
      params.require(:project).permit(:title, :description, :results, :project_status_id)
    end
end
