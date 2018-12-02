class ProjectsController < ApplicationController
	include Pagination
  before_action :set_project, only: [:destroy]

  # GET /projects
  # GET /projects?search=query
  def index
    @user = auth_user

    if params[:search].present?
      @pagy, @projects = pagy(Project.matching(params[:search]).with_main_infos.order(created_at: :desc))
    elsif @user.categories.any?
      @pagy, @projects = pagy(Project.for_user_home(@user).open.order(created_at: :desc))
    else
      @pagy, @projects = pagy(Project.with_main_infos.open.order(created_at: :desc))
    end

    @serializer_options[:include] = [:admins, :project_status, :categories]
    @serializer_options.merge!(pagination_options(@pagy))

    render json: ProjectSerializer.new(@projects, @serializer_options).serialized_json
  end

  # GET /projects/by_categories?project[categories][]=1
  def by_categories
    unless params[:project][:categories].present? && params[:project][:categories].any?
      return render json: ErrorSerializer.new('La ricerca deve contenere almeno una categoria', status_code(:unprocessable_entity)).serialized_json, status: :unprocessable_entity
    end

    categories_ids = params[:project][:categories]

    @pagy, @projects = pagy(Project.by_categories(categories_ids).order(created_at: :desc))

    @serializer_options[:include] = [:admins, :project_status, :categories]
    @serializer_options.merge!(pagination_options(@pagy))

    render json: ProjectSerializer.new(@projects, @serializer_options).serialized_json
  end

  # GET /projects/:id
  def show
    @project = Project.with_full_infos.find(params[:id])

    @serializer_options[:include] = [:admins, :collaborators, :project_status, :categories]

    render json: ProjectSerializer.new(@project, @serializer_options).serialized_json
  end

  # POST /projects
  def create
	  categories_ids = params[:project][:categories]
	  collaborators_ids = params[:project][:collaborators]

    unless categories_ids.present? && categories_ids.any?
      return render json: ErrorSerializer.new('Il progetto deve contenere almeno una categoria', status_code(:unprocessable_entity)).serialized_json, status: :unprocessable_entity
    end

    @project = Project.new(project_params)
    @project.admins << auth_user
    @project.categories = Category.find(categories_ids)

    if collaborators_ids.present? && collaborators_ids.any?
      @project.collaborators = User.with_attached_avatar.find(collaborators_ids)
    end

    if @project.save
	    @serializer_options[:include] = [:collaborators, :admins, :project_status, :categories]
      @serializer_options[:meta][:messages] = ['Progetto creato con successo!']

      render json: ProjectSerializer.new(@project, @serializer_options).serialized_json
    else
      render json: ErrorSerializer.new(@project.errors, status_code(:unprocessable_entity)).serialized_json, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/:id
  def update
	  categories_ids = params[:project][:categories]
	  collaborators_ids = params[:project][:collaborators]

    unless auth_user.admin? params[:id]
      return render json: ErrorSerializer.new('Non puoi aggiornare il progetto se non sei l\'admin', status_code(:forbidden)).serialized_json, status: :forbidden
    end

    @project = Project.with_full_infos.find(params[:id])

	  unless categories_ids.present? && categories_ids.any?
      return render json: ErrorSerializer.new('Il progetto deve contenere almeno una categoria', status_code(:unprocessable_entity)).serialized_json, status: :unprocessable_entity
    end

    @project.categories = Category.find(categories_ids)

    if collaborators_ids.present? && collaborators_ids.any?
      @project.collaborators = User.with_attached_avatar.find(collaborators_ids)
    else
      @project.collaborators.delete_all
    end

    if @project.update(project_params)
      @serializer_options[:meta][:messages] = ['Progetto aggiornato con successo!']

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

    @serializer_options[:meta][:messages] = ['Progetto eliminato con successo!']

    render json: ProjectSerializer.new(@project, @serializer_options).serialized_json
  end

  # GET /category/:category_id/projects
  def category_projects
    @pagy, @projects = pagy(Category.find(params[:category_id]).projects.with_main_infos.order(created_at: :desc))

    @serializer_options[:include] = [:admins, :project_status, :categories]
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
      @projects = User.find(user_id).created_projects.with_main_infos.order(created_at: :desc)
    when '0'
      @projects = User.find(user_id).joined_projects.with_main_infos.order(created_at: :desc)
    else
      @projects = User.find(user_id).projects.with_main_infos.order(created_at: :desc)
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
    @serializer_options[:include] = [:admins, :project_status, :categories]
    @serializer_options.merge!(pagination_options(@pagy))

    render json: ProjectSerializer.new(@projects, @serializer_options).serialized_json
  end

  # DELETE /projects/:project_id/documents
  def documents_destroy
    unless auth_user.admin? params[:project_id]
      return render json: ErrorSerializer.new('Non puoi eliminare documenti se non sei l\'admin', status_code(:forbidden)).serialized_json, status: :forbidden
    end

    @documents = ActiveStorage::Attachment.find(params[:documents])
    messages = []

    @documents.each do |document|
      document.purge
      messages.push("'#{document.blob.filename}' eliminato con successo!")
    end

    @serializer_options[:meta][:messages] = messages

    render json: ProjectSerializer.new(@project, @serializer_options).serialized_json
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
	    @project = Project.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def project_params
      params.require(:project).permit(:title, :description, :results, :project_status_id, :categories, :collaborators, documents: [])
    end
end
