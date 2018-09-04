class User < ApplicationRecord
	has_secure_password
	validates :firstname, presence: true
	validates :lastname, presence: true
	validates :email, presence: true, uniqueness: true

  belongs_to :course

  has_many :study_groups

	has_many :project_users
  has_many :projects_memberships, :through => :project_users, :source => :project

	has_and_belongs_to_many :categories
end
