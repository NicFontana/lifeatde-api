class ErrorSerializer

	def initialize(messages, status)
		@messages = messages
		@status = status
	end

	def serialized_json
		case @messages
		when ActiveModel::Errors
			serialize_form_errors.to_json
		when Array
			serialize_array.to_json
		else
			serialize_string.to_json
		end
	end

	private
		def serialize_form_errors
			response = { errors: [] }
			@messages.each do |attribute, message|
				error = {
						status: @status,
						source: attribute,
						detail: message
				}
				response[:errors].push(error)
			end
			response
		end

		def serialize_array
			response = { errors: [] }
			@messages.each do |message|
				error = {
						status: @status,
						detail: message
				}
				response[:errors].push(error)
			end
			response
		end

		def serialize_string
			response = { errors: [] }
			error = {
					status: @status,
					detail: @messages
			}
			response[:errors].push(error)
			response
		end
end