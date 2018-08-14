class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :firstname, :lastname, :email, :bio, :birthday, :phone, :profile_picture_path
  belongs_to :course
end
