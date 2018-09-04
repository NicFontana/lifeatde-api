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
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:firstname, :lastname, :email, :password_digest, :bio, :birthday, :phone)
    end
end
