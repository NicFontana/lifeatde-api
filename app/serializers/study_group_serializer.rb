class StudyGroupSerializer
  include FastJsonapi::ObjectSerializer

  attributes :title, :description
  belongs_to :user, if: Proc.new { |record, params| record.association(:user).loaded? }
  belongs_to :course, if: Proc.new { |record, params| record.association(:course).loaded? }
end
