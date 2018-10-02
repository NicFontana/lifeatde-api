class AuthenticationController < ApplicationController
	def login
		@user = User.includes(:course, :categories).find_by(email: params[:email].to_s.downcase)

		if @user && @user.authenticate(params[:password])
			token = JsonWebToken.encode({user_id: @user.id})

			@serializer_options[:params] = {token: token}
			@serializer_options[:include] = [:course, :categories]
			@serializer_options[:meta][:messages] = ['Login effettuato con successo!']

			render json: UserSerializer.new(@user, @serializer_options).serialized_json
		else
			render json: ErrorSerializer.new('Credenziali errate!', status_code(:not_found)).serialized_json, status: :not_found
		end
	end
end
