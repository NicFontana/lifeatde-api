class UsersController < ApplicationController
  include Pagination
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /usersz
  def index
    @pagy, @users = pagy(User.all)
    render json: UserSerializer.new(@users, pagination_options).serialized_json
  end

  # GET /users/1
  def show
    render json: UserSerializer.new(@user).serialized_json
  end

  # PATCH/PUT /users/1
  def update
    unless @user.id == get_auth_user.id
      return render json: ErrorSerializer.new('You can update only your profile', 403).serialized_json, status: :forbidden
    end

    if @user.update(user_params)
      render json: UserSerializer.new(@user).serialized_json
    else
			render json: ErrorSerializer.new(@user.errors, 422).serialized_json, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
	    begin
        @user = User.find(params[:id])
	    rescue ActiveRecord::RecordNotFound => e
				render json: ErrorSerializer.new(e.message, 404).serialized_json, status: :not_found
	    end
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
	    params.require(:user).permit(:firstname, :lastname, :email, :password_digest, :bio, :birthday, :phone)
    end
end
