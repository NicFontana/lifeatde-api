class ProjectSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :description, :results

  has_many :admin, serializer: :user, if: Proc.new { |record, params| record.association(:admin).loaded? }
  has_many :members, if: Proc.new { |record, params| record.association(:members).loaded? }
  has_many :documents, if: Proc.new { |record, params| record.association(:documents).loaded? }

  attribute :admin, if: Proc.new { |record, params| record.association(:projects_users).loaded? } do |project, params|
    project.projects_users.detect{ |record| record.user_id == params[:user_id].to_i }.admin
  end
  attribute :status do|project, params|
    project.project_status.name
  end
end