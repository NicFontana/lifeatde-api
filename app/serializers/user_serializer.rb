class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :firstname, :lastname, :email, :bio, :birthday, :phone, :profile_picture_path

  belongs_to :course, if: Proc.new { |record, params| record.association(:course).loaded? }
  has_many :projects, if: Proc.new { |record, params| record.association(:projects).loaded? }
  has_many :study_groups, if: Proc.new { |record, params| record.association(:study_groups).loaded? }

  attribute :admin, if: Proc.new { |record, params| params && params[:project_id].present? && record.association(:projects_users).loaded? } do |user, params|
    user.projects_users.detect{ |record| record.project_id == params[:project_id].to_i }.admin
  end
end
