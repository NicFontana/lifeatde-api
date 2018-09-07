class ProjectSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :description, :results
  belongs_to :project_status
  has_many :members
  has_many :documents
end