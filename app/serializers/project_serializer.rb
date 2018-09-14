class ProjectSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :description, :results

  has_many :admins, serializer: :user, record_type: :user, if: Proc.new { |record, params| record.association(:admins).loaded? }
  has_many :collaborators, serializer: :user, record_type: :user, if: Proc.new { |record, params| record.association(:collaborators).loaded? }
  has_many :members, serializer: :user, record_type: :user, if: Proc.new { |record, params| record.association(:members).loaded? }
  has_many :documents, if: Proc.new { |record, params| record.association(:documents).loaded? }

  attribute :is_admin, if: Proc.new { |record, params| params && params[:user_id].present? && record.association(:projects_users).loaded? } do |project, params|
    project.projects_users.detect{ |record| record.user_id == params[:user_id].to_i }.admin
  end
  attribute :status do |project, params|
    project.project_status.name
  end

  attribute :categories do |project, params|
    categories = []
    project.categories.each do |category|
      categories << category.name
    end
    categories
  end

end