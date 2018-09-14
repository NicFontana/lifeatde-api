class StudyGroupSerializer
  include FastJsonapi::ObjectSerializer

  attributes :title, :description

  belongs_to :user, if: Proc.new { |record, params| record.association(:user).loaded? }

  attribute :course, if: Proc.new { |record, params| record.association(:course).loaded? } do |study_group, params|
    study_group.course.name
  end
end
