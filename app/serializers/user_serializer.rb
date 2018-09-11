class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :firstname, :lastname, :email, :bio, :birthday, :phone, :profile_picture_path

  belongs_to :course, if: Proc.new { |record, params| record.association(:course).loaded? }
  has_many :all_projects, if: Proc.new { |record, params| record.association(:all_projects).loaded? }
  has_many :study_groups, if: Proc.new { |record, params| record.association(:study_groups).loaded? }
end
