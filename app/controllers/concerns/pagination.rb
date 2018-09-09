module Pagination
  extend ActiveSupport::Concern

  included do
    include Pagy::Backend

    def pagination_options(pagy)
      options = Hash.new
      options[:is_collection] = true
      options[:meta] = {
          items: pagy.count == 0 ? 0 : pagy.items,
          pages: pagy.pages,
          next: pagy.next,
          self: pagy.page,
          prev: pagy.prev,
          last: pagy.last
      }
      options
    end

  end
end