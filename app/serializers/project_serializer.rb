class ProjectSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :description, :results, :created_at

  has_many :admins, serializer: :user, record_type: :user, if: Proc.new { |record, params| record.association(:admins).loaded? }
  has_many :collaborators, serializer: :user, record_type: :user, if: Proc.new { |record, params| record.association(:collaborators).loaded? }
  has_many :members, serializer: :user, record_type: :user, if: Proc.new { |record, params| record.association(:members).loaded? }

  attribute :documents, if: Proc.new { |record, params| record.association(:documents_attachments).loaded? } do |object|
    if object.documents.attached?
      documents = []
      object.documents.each do |document|
        documents << {
            id: document.id,
            url: Rails.application.routes.url_helpers.rails_blob_url(document, only_path: true),
            filename: document.filename.to_s,
            content_type: document.content_type.to_s
        }
      end
      documents
    else
      nil
    end
  end

  attribute :status do |project, params|
    {
      id: project.project_status.id,
      name: project.project_status.name
    }
  end

  attribute :categories do |project, params|
    categories = []
    project.categories.each do |category|
      categories << {
        id: category.id,
        name: category.name
      }
    end
    categories
  end

end