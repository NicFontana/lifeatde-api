class User < ApplicationRecord
	has_secure_password
	validates :phone, numericality: { only_integer: true, message: 'Deve contenere solo numeri.' }

	has_one_attached :avatar

  belongs_to :course

  has_many :study_groups

	has_many :projects_users
	has_many :projects, :through => :projects_users, :source => :project, inverse_of: :members
  has_many :joined_projects, -> { where(projects_users: {admin: false}) }, :through => :projects_users, :source => :project, inverse_of: :collaborators
	has_many :created_projects, -> { where(projects_users: {admin: true}) }, :through => :projects_users, :source => :project, inverse_of: :admins

	has_and_belongs_to_many :categories

	def admin?(project_id)
		record = projects_users.detect{ |el| el.project_id == project_id.to_i }
		record.nil? ? false : record.admin
	end
end
