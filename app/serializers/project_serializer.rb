class ProjectSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :description, :results
  belongs_to :project_status, if: Proc.new { |record, params| record.association(:project_status).loaded? }
  has_many :members, if: Proc.new { |record, params| record.association(:members).loaded? }
  has_many :documents, if: Proc.new { |record, params| record.association(:documents).loaded? }
end