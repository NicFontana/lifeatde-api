class ApplicationController < ActionController::API
	# Sets the @current_user with the user_id from token payload
	def auth_user
		User.find_by(id: request.env['jwt.payload']['user_id'])
	end

	rescue_from ActionController::ParameterMissing do |error|
		render json: ErrorSerializer.new(error.message, Rack::Utils.status_code(:bad_request)).serialized_json, status: :bad_request
	end
	rescue_from ActiveRecord::RecordNotFound do |error|
		render json: ErrorSerializer.new(error.message, Rack::Utils.status_code(:not_found)).serialized_json, status: :not_found
	end
end
