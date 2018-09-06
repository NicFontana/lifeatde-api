class User < ApplicationRecord
	has_secure_password

  belongs_to :course

  has_many :study_groups

	has_many :project_users
  has_many :projects_memberships, :through => :project_users, :source => :project

	has_and_belongs_to_many :categories
end
