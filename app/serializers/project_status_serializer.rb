class ProjectStatusSerializer
  include FastJsonapi::ObjectSerializer

  has_many :projects, if: Proc.new { |record, params| record.association(:projects).loaded? }

end