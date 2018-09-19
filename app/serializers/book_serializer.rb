class BookSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :description, :price, :created_at

  belongs_to :user, if: Proc.new { |record, params| record.association(:user).loaded? }

  attribute :course, if: Proc.new { |record, params| record.association(:course).loaded? } do |book, params|
    book.course.name
  end

  attribute :photos do |object|
    if object.photos.attached?
      photos = []
      object.photos.each do |photo|
        photos << {
            id: photo.id,
            url: Rails.application.routes.url_helpers.rails_blob_url(photo)
        }
      end
      photos
    else
      nil
    end
  end
end
