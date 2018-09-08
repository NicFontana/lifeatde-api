class UsersController < ApplicationController
  include Pagination
  include Rack::Utils
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users/:id
  def show
    render json: UserSerializer.new(@user).serialized_json
  end

  # PATCH/PUT /users/:id
  def update
    unless @user.id == auth_user.id
      return render json: ErrorSerializer.new('You can update only your profile', status_code(:forbidden)).serialized_json, status: :forbidden
    end

    if @user.update(user_params)
      render json: UserSerializer.new(@user).serialized_json
    else
			render json: ErrorSerializer.new(@user.errors, status_code(:unprocessable_entity)).serialized_json, status: :unprocessable_entity
    end
  end

  # POST /projects/:project_id/users/:id/add_member
  def add
    @member = @user.projects_users.new(project_id: params[:project_id], admin: false)

    if @member.save
      render json: UserSerializer.new(@user).serialized_json
    else
      render json: ErrorSerializer.new(@user.errors, status_code(:unprocessable_entity)).serialized_json, status: :unprocessable_entity
    end
  end

  # DELETE /projects/:project_id/users/:id/add_member
  def remove
    @member = @user.projects_users.where(project_id: params[:project_id], admin: false)

    if @member.destroy_all
      render json: UserSerializer.new(@user).serialized_json
    else
      render json: ErrorSerializer.new(@user.errors, status_code(:unprocessable_entity)).serialized_json, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
	    @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
	    params.require(:user).permit(:bio, :phone, :profile_picture_path)
    end
end
