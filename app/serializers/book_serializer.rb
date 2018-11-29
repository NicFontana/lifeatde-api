class BookSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :description, :price, :created_at
  attribute :photos do |object|
    if object.photos.attached?
      photos = []
      object.photos.each do |photo|
        photos << {
            id: photo.id,
            url: Rails.application.routes.url_helpers.rails_blob_url(photo, only_path: true),
            name: photo.filename.to_s,
            byte_size: photo.byte_size.to_i,
            content_type: photo.content_type.to_s
        }
      end
      photos
    else
      nil
    end
  end

  belongs_to :user, if: Proc.new { |record, params| record.association(:user).loaded? }
  belongs_to :course, if: Proc.new { |record, params| record.association(:course).loaded? }
end
