class UsersController < ApplicationController
  include Pagination
  before_action :set_user, only: [:show, :update, :avatar_destroy]

  # GET /users/:id
  def show
    render json: UserSerializer.new(@user).serialized_json
  end

  # PATCH/PUT /users/:id
  def update
    unless @user.id == auth_user.id
      return render json: ErrorSerializer.new('Puoi aggiornare solo il tuo profilo', status_code(:forbidden)).serialized_json, status: :forbidden
    end

    if @user.update(user_params)
      @serializer_options[:meta][:messages] = ['Profilo aggiornato con successo!']

      render json: UserSerializer.new(@user, @serializer_options).serialized_json
    else
			render json: ErrorSerializer.new(@user.errors, status_code(:unprocessable_entity)).serialized_json, status: :unprocessable_entity
    end
  end

  #GET /users/me
  def me
    user = User.includes(:course, :categories).find_by(id: request.env['jwt.payload']['user_id'])

    @serializer_options[:include] = [:course, :categories]

    render json: UserSerializer.new(user, @serializer_options).serialized_json
  end

  # POST /projects/:project_id/members
  def members_create
    @project = Project.includes(:admins).find(params[:project_id])
    @collaborators = User.includes(:projects_users).find(params[:users][:ids])
    @current_user = auth_user

    unless @current_user.admin? params[:project_id]
      return render json: ErrorSerializer.new('Non puoi aggiungere membri se non sei l\'admin del progetto', status_code(:forbidden)).serialized_json, status: :forbidden
    end

    if @project.collaborators << @collaborators
      @serializer_options[:params] = {project_id: params[:project_id]}
      @serializer_options[:meta][:messages] = ['Membri aggiunti con successo!']

      render json: UserSerializer.new(@collaborators, @serializer_options).serialized_json
    else
      render json: ErrorSerializer.new(@project.errors, status_code(:unprocessable_entity)).serialized_json, status: :unprocessable_entity
    end
  end

  # DELETE /projects/:project_id/members
  def members_destroy
    @project = Project.includes(:admins).find(params[:project_id])
    @collaborators = User.includes(:projects_users).find(params[:user][:ids])
    @current_user = auth_user

    unless @current_user.admin? params[:project_id]
      return render json: ErrorSerializer.new('Non puoi rimuovere membri se non sei l\'admin del progetto', status_code(:forbidden)).serialized_json, status: :forbidden
    end

    @project.collaborators.delete(@collaborators)

    @serializer_options[:params] = {project_id: params[:project_id]}
    @serializer_options[:meta][:messages] = ['Membri eliminati con successo!']

    render json: UserSerializer.new(@collaborators, @serializer_options).serialized_json
  end

  # GET /projects/:id/members
  def members_index
    @pagy, @members = pagy(Project.find(params[:project_id]).members.includes(:projects_users))

    @serializer_options[:params] = {project_id: params[:project_id]}
    @serializer_options.merge!(pagination_options(@pagy))

    render json: UserSerializer.new(@members, @serializer_options).serialized_json
  end

  # DELETE /users/:id/avatar
  def avatar_destroy
    @avatar = ActiveStorage::Attachment.find(params[:avatar])
    @avatar.purge

    @serializer_options[:meta][:messages] = ['Immagine del profilo rimossa con successo!']

    render json: UserSerializer.new(@user, @serializer_options).serialized_json
  end
  
  # GET /users?not_in_project=:id&search=querystring
  def search
    querystring = params[:search]

    if querystring.present?
      if params[:not_in_project].present?
        members = Project.find(params[:not_in_project]).members
        @pagy, users = pagy(User.where.not(id: members.ids).matching(querystring))
      else
        @pagy, users = pagy(User.matching(querystring))
      end
    else
      return render json: ErrorSerializer.new('Inserire una striga di ricerca per l\'utente', status_code(:bad_request)).serialized_json, status: :bad_request
    end

    @serializer_options.merge!(pagination_options(@pagy))
    render json: UserSerializer.new(users, @serializer_options).serialized_json
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
	    @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
	    params.require(:user).permit(:bio, :phone, :avatar)
    end
end
