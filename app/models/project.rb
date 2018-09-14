class Project < ApplicationRecord
	validates :title, presence: { message: 'Il progetto deve avere un titolo' }
	validates :description, presence: { message: 'Il progetto deve avere una descrizione' }

	statuses = {
			open: 1,
			closed: 2,
			terminated: 3
	}

  belongs_to :project_status

	has_many :projects_users
	has_many :members, :through => :projects_users, :source => :user, inverse_of: :projects
	has_many :collaborators, -> {where(projects_users: {admin: false})}, :through => :projects_users, :source => :user, inverse_of: :joined_projects
	has_many :admins, -> {where(projects_users: {admin: true})}, :through => :projects_users, :source => :user, inverse_of: :created_projects

	has_and_belongs_to_many :categories

	has_many :documents

	scope :open, -> { where(project_status_id: statuses[:open]) }
	scope :closed, -> { where(project_status_id: statuses[:closed]) }
	scope :terminated, -> { where(project_status_id: statuses[:terminated]) }

	scope :matching, -> (querystring) {where('projects.title LIKE ? OR projects. description LIKE ?', "%#{querystring}%", "%#{querystring}%")}

	def self.for_user(auth_user)
		joins(:categories).where(categories_projects: {category_id: auth_user.categories.ids})
	end
end
