class UsersController < ApplicationController
  include Pagination
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users/1
  def show
    render json: UserSerializer.new(@user).serialized_json
  end

  # PATCH/PUT /users/1
  def update
    unless @user.id == auth_user.id
      return render json: ErrorSerializer.new('You can update only your profile', Rack::Utils.status_code(:forbidden)).serialized_json, status: :forbidden
    end

    if @user.update(user_params)
      render json: UserSerializer.new(@user).serialized_json
    else
			render json: ErrorSerializer.new(@user.errors, Rack::Utils.status_code(:unprocessable_entity)).serialized_json, status: :unprocessable_entity
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
	    params.require(:user).permit(:bio, :phone, :profile_picture_path)
    end
end
