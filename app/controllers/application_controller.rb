class ApplicationController < ActionController::API
	# Sets the @current_user with the user_id from token payload
	def auth_user
		User.find_by(id: request.env['jwt.payload']['user_id'])
	end

	rescue_from ActionController::ParameterMissing do |error|
		render json: ErrorSerializer.new(error.message, 400).serialized_json, status: :bad_request
	end
end
