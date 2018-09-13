class SuccessSerializer

	def initialize(message, status)
		@message = message
		@status = status
	end

	def serialized_json
		{
				meta: {
						status: @status,
						message: @message
				}
		}
	end
end