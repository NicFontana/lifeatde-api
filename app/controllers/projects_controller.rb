class ProjectsController < ApplicationController
	include Pagination
  before_action :set_project, only: [:update, :destroy, :documents]

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

  # GET /projects/:id
  def show
    @project = Project.includes(:project_status, :categories, members: [:projects_users]).find(params[:id])

    @serializer_options[:include] = [:members]
    @serializer_options[:params] = { project_id: params[:id] }

    render json: ProjectSerializer.new(@project, @serializer_options).serialized_json
  end

  # POST /projects
  def create
    unless params[:project][:categories].present? && params[:project][:categories].any?
      return render json: ErrorSerializer.new('Il progetto deve contenere almeno una categoria', status_code(:unprocessable_entity)).serialized_json, status: :unprocessable_entity
    end

    @categories = Category.find(params[:project][:categories])
    @project = Project.new(project_params)

    @project.projects_users.build(admin: true, user_id: auth_user.id)

    if @project.save && @project.categories << @categories
      @serializer_options[:meta][:message] = 'Progetto creato con successo!'

      render json: ProjectSerializer.new(@project, @serializer_options).serialized_json
    else
      render json: ErrorSerializer.new(@project.errors, status_code(:unprocessable_entity)).serialized_json, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/:id
  def update
    unless auth_user.admin? params[:id]
      return render json: ErrorSerializer.new('Non puoi aggiornare il progetto se non sei l\'admin', status_code(:forbidden)).serialized_json, status: :forbidden
    end

    if params[:project][:categories].present? &&  params[:project][:categories].all?(&:blank?)
      return render json: ErrorSerializer.new('Il progetto deve contenere almeno una categoria', status_code(:unprocessable_entity)).serialized_json, status: :unprocessable_entity
    end

    @categories = Category.find(params[:project][:categories])

    if @project.update(project_params)
      @project.categories = @categories

      @serializer_options[:meta][:message] = 'Progetto aggiornato con successo!'

      render json: ProjectSerializer.new(@project, @serializer_options).serialized_json
    else
      render json: ErrorSerializer.new(@project.errors, status_code(:unprocessable_entity)).serialized_json, status: :unprocessable_entity
    end
  end

  # DELETE /projects/:id
  def destroy
    unless auth_user.admin? params[:id]
      return render json: ErrorSerializer.new('Non puoi eliminare il progetto se non sei l\'admin', status_code(:forbidden)).serialized_json, status: :forbidden
    end

    @project.destroy

    @serializer_options[:meta][:message] = 'Progetto eliminato con successo!'

    render json: ProjectSerializer.new(@project, @serializer_options).serialized_json
  end

  # GET /category/:category_id/projects
  def category_projects
    @pagy, @projects= pagy(Category.find(params[:category_id]).projects.includes(:admins, :project_status).order(created_at: :desc))

    @serializer_options[:include] = [:admins]
    @serializer_options.merge!(pagination_options(@pagy))

    render json: ProjectSerializer.new(@projects, @serializer_options).serialized_json
  end

  # GET /users/:user_id/projects?status=&admin=1\0
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
      @projects = User.find(user_id).projects.includes(:projects_users, :project_status, :categories).order(created_at: :desc)
    end

    case status
    when 'open'
      @projects = @projects.open
    when 'closed'
      @projects = @projects.closed
    when 'terminated'
      @projects = @projects.terminated
    else
      return render json: ErrorSerializer.new("Parametro status = #{status} non riconosciuto. Consentiti: 'open', 'closed', 'terminated'", status_code(:forbidden)).serialized_json, status: :forbidden
    end

    @pagy, @projects = pagy(@projects)
    @serializer_options[:params] = { user_id: user_id }
    @serializer_options.merge!(pagination_options(@pagy))

    render json: ProjectSerializer.new(@projects, @serializer_options).serialized_json
  end

  # DELETE /project/:id/documents
  def documents_destroy
    @documents = ActiveStorage::Attachment.find(params[:documents])
    messages = []

    @documents.each do |document|
      document.purge
      messages.push("'#{document.blob.filename}' eliminato con successo!")
    end

    @serializer_options[:meta][:message] = messages

    render json: ProjectSerializer.new(@project, @serializer_options).serialized_json
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
	    @project = Project.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def project_params
      params.require(:project).permit(:title, :description, :results, :project_status_id, documents: [])
    end
end
