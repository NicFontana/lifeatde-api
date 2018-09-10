class ProjectStatusSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name
  has_many :projects, if: Proc.new { |record, params| record.association(:projects).loaded? }

end