class Project < ApplicationRecord
  belongs_to :project_status

	has_many :project_users
	has_many :members, :through => :project_users, :source => :user

	has_and_belongs_to_many :categories

	has_many :documents
end
