class Project < ApplicationRecord
	validates :title, presence: {message: 'Questo campo non può essere vuoto'}
	validates :description, presence: {message: 'Questo campo non può essere vuoto'}

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

	has_many_attached :documents

	scope :open, -> { where(project_status_id: statuses[:open]) }
	scope :closed, -> { where(project_status_id: statuses[:closed]) }
	scope :terminated, -> { where(project_status_id: statuses[:terminated]) }

	scope :matching, -> (querystring) {where('title LIKE ? OR description LIKE ?', "%#{querystring}%", "%#{querystring}%")}

	def self.of_categories_with_main_infos(categories_ids)
		#includes will only fetch Category records of categories_ids,
		#not all categories associated with each project.
		joins(:categories)
				.where(categories: {id: categories_ids})
				.preload(:categories)
				.includes(:project_status, admins: [:avatar_attachment])
	end

	def self.with_main_infos
		includes(:project_status, :categories, admins: [:avatar_attachment])
	end

	def self.with_full_infos
		includes(:project_status, :categories, admins: [:avatar_attachment], collaborators: [:avatar_attachment])
		.with_attached_documents
	end

end
