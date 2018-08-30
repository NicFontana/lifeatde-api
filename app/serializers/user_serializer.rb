class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :firstname, :lastname, :email, :bio, :birthday, :phone, :profile_picture_path
  belongs_to :course
  has_many :projects
  has_many :projects_memberships
  has_many :study_groups
end
