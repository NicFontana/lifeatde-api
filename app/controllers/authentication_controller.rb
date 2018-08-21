class AuthenticationController < ApplicationController
	def login
		@user = User.find_by(email: params[:email].to_s.downcase)

		if @user && @user.authenticate(params[:password])
			auth_token = JsonWebToken.encode({user_id: @user.id})
			render json: {:data => [{token: auth_token}]}, status: :ok
		else
			render json: {:errors => [{:status => Rack::Utils.status_code(:not_found), :detail => 'Invalid credentials'}]}
		end
	end
end
