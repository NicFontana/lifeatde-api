class User < ApplicationRecord
  belongs_to :course

  has_many :projects
  has_many :study_groups

	has_many :project_users
  has_many :projects_memberships, :through => :project_users, :source => :project

	has_many :user_categories
	has_many :favourites_categories, :through => :user_categories, :source => :category
end
