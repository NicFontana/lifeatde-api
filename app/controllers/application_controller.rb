class ApplicationController < ActionController::API
	include Rack::Utils
	before_action :create_serializer_options

	rescue_from ActionController::ParameterMissing do |error|
		render json: ErrorSerializer.new(error.message, status_code(:bad_request)).serialized_json, status: :bad_request
	end
	rescue_from ActiveRecord::RecordNotFound do |error|
		render json: ErrorSerializer.new(error.message, status_code(:not_found)).serialized_json, status: :not_found
	end
	rescue_from ActiveRecord::RecordNotUnique do |error|
		render json: ErrorSerializer.new(error.message, status_code(:internal_server_error)).serialized_json, status: :internal_server_error
	end
	rescue_from Pagy::OverflowError do |error|
		render json: ErrorSerializer.new(error.message, status_code(:internal_server_error)).serialized_json, status: :internal_server_error
	end

	def create_serializer_options
		@serializer_options = { include: [], params: {}, meta: {} }
	end

	# Sets the @current_user with the user_id from token payload
	def auth_user
		User.find_by(id: request.env['jwt.payload']['user_id'])
	end

end
