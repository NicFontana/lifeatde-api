class AuthenticationController < ApplicationController
	def login
		@user = User.find_by(email: params[:email].to_s.downcase)

		if @user && @user.authenticate(params[:password])
			token = JsonWebToken.encode({user_id: @user.id})

			@serializer_options[:params] = {token: token}

			render json: UserSerializer.new(@user, @serializer_options).serialized_json
		else
			render json: ErrorSerializer.new(@user.errors, status_code(:not_found)).serialized_json, status: :not_found
		end
	end
end
