class Project < ApplicationRecord
	validates :title, presence: true
	validates :description, presence: true

  belongs_to :project_status

	has_many :projects_users
	has_many :members, :through => :projects_users, :source => :user

	has_and_belongs_to_many :categories

	has_many :documents

	def self.for_user(auth_user)
		joins(:categories).where(categories_projects: {category_id: auth_user.categories.ids})
	end

	def self.by_category(category_id)
		joins(:categories).where(categories: {id: category_id})
	end

	def self.by_querystring(search)
		where('projects.title LIKE ? ', "%#{search}%")
	end

	def self.of_user(user_id)
		joins(:members).where(users: {id: user_id})
	end

	def self.of_user_by_role(user_id,admin)
		joins(:members).where(users: {id: user_id}).where(projects_users: {admin: admin})
	end

	def self.open_of_user(user_id)
		joins(:members).where(users: {id: user_id}).where(project_status_id: 1)
	end

	def self.closed_of_user(user_id)
		joins(:members).where(users: {id: user_id}).where(project_status_id: 2)
	end

	def self.terminated_of_user(user_id)
		joins(:members).where(users: {id: user_id}).where(project_status_id: 3)
	end

end
