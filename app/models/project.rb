class Project < ApplicationRecord
  belongs_to :user
  alias_attribute :owner, :user

  belongs_to :project_status

	has_many :project_users
	has_many :members, :through => :project_users, :source => :user

	has_many :project_categories
	has_many :categories, :through => :project_categories

	has_many :documents
end
