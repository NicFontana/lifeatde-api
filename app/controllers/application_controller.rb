class ApplicationController < ActionController::API
	# Sets the @current_user with the user_id from token payload
	def get_auth_user
		User.find_by(id: request.env['jwt.payload']['user_id'])
	end
end
