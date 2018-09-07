class Project < ApplicationRecord
	validates :title, presence: true
	validates :description, presence: true

  belongs_to :project_status

	has_many :projects_users
	has_many :members, :through => :projects_users, :source => :user

	has_and_belongs_to_many :categories

	has_many :documents

	def self.category_projects(category_id)
		left_outer_joins(:categories).where('categories.id = ?',category_id)
	end

	def self.user_projects(user_id)
		joins(:members).where('users.id = ? AND projects_users.admin = 1', user_id)
	end

	def self.user_related_projects(auth_user)
		projects = []
		auth_user.categories.each do |category|
			projects << joins(:categories).where('categories_projects.category_id = ?', category.id)
		end
		projects
	end

	def self.get_project_by_querystring(search)
		where('projects.title LIKE ? ', "%#{search}%")
	end

end
