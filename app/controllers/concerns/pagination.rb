module Pagination
	extend ActiveSupport::Concern

	included do
		include Pagy::Backend

		def pagination_options
			options = Hash.new
			options[:is_collection] = true
			options[:meta] = {
					items: @pagy.items,
					pages: @pagy.pages,
					next: @pagy.next,
					self: @pagy.page,
					prev: @pagy.prev,
					last: @pagy.last
			}
			return options
		end

	end
end