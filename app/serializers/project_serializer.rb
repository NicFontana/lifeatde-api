class ProjectSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :description, :results, :created_at
  attribute :documents, if: Proc.new { |record, params| record.association(:documents_attachments).loaded? } do |object|
    if object.documents.attached?
      documents = []
      object.documents.each do |document|
        documents << {
            id: document.id,
            url: Rails.application.routes.url_helpers.rails_blob_url(document, only_path: true),
            name: document.filename.to_s,
            byte_size: document.byte_size.to_i,
            content_type: document.content_type.to_s
        }
      end
      documents
    else
      nil
    end
  end

  has_many :admins, serializer: :user, record_type: :user, if: Proc.new { |record, params| record.association(:admins).loaded? }
  has_many :collaborators, serializer: :user, record_type: :user, if: Proc.new { |record, params| record.association(:collaborators).loaded? }
  has_many :members, serializer: :user, record_type: :user, if: Proc.new { |record, params| record.association(:members).loaded? }

  belongs_to :project_status, if: Proc.new { |record, params| record.association(:project_status).loaded? }
  has_many :categories, if: Proc.new { |record, params| record.association(:categories).loaded? }
end