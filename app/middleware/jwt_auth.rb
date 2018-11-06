require_relative '../../lib/json_web_token'

class JWTAuth

	attr_accessor :exclude

	def initialize app, exluded_path
		@app = app
		@exclude = exluded_path

		check_exclude_type!
	end

	def call env
		dup._call env
	end

	def _call env
		if path_matches_excluded_path? env
			@app.call env
		elsif missing_auth_header? env
			error_response 'Non sei autorizzato ad accedere alla risorsa'
		else
			verify_token env
		end
	end

	# Deconstructs the Authorization header and decodes the JWT token.
	private
	def verify_token env
		token = env['HTTP_AUTHORIZATION'].split(' ')[1]

		begin
			decoded_token = JsonWebToken.decode(token)
		rescue JWT::DecodeError
			return error_response 'Sessione scaduta'
		end

		unless JsonWebToken.valid_payload?(decoded_token.first)
			return error_response 'Sessione scaduta'
		end

		env['jwt.payload'] = decoded_token.first
		env['jwt.header'] = decoded_token.last
		@app.call env
	end

	private
	def missing_auth_header? env
		env['HTTP_AUTHORIZATION'].nil? || env['HTTP_AUTHORIZATION'].strip.empty?
	end

	private
	def check_exclude_type!
		unless @exclude.is_a?(Array)
			raise ArgumentError, 'exclude argument must be an Array'
		end

		@exclude.each do |x|
			unless x.is_a?(String)
				raise ArgumentError, 'each exclude Array element must be a String'
			end

			if x.empty?
				raise ArgumentError, 'each exclude Array element must not be empty'
			end

			unless x.start_with?('/')
				raise ArgumentError, 'each exclude Array element must start with a /'
			end
		end
	end

	private
	def path_matches_excluded_path? env
		@exclude.any? { |ex| env['PATH_INFO'].start_with?(ex) }
	end

	private
	def error_response message
		headers = { 'Content-Type' => 'application/json' }
		body = ErrorSerializer.new(message, Rack::Utils.status_code(:unauthorized)).serialized_json

		[Rack::Utils.status_code(:unauthorized), headers, [body]]
	end

end