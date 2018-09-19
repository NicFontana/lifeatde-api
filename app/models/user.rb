class User < ApplicationRecord
	has_secure_password
	validates :phone, numericality: { only_integer: true, message: 'Deve contenere solo numeri.' }
	validates :profile_picture_path, format: { with: /\A(?:\/?|\\?+[\w-]+\/?|\\?)+[.]+[a-zA-Z]+\z/, message: 'Non è valido.' }

  belongs_to :course

  has_many :study_groups

	has_many :projects_users
	has_many :projects, :through => :projects_users, :source => :project, inverse_of: :members
  has_many :joined_projects, -> { where(projects_users: {admin: false}) }, :through => :projects_users, :source => :project, inverse_of: :collaborators
	has_many :created_projects, -> { where(projects_users: {admin: true}) }, :through => :projects_users, :source => :project, inverse_of: :admins

	has_and_belongs_to_many :categories

	def self.matching(querystring)
		querystrings = querystring.split
		first = querystrings.first
		querystrings.drop(1)

		query = where('firstname LIKE ? OR lastname LIKE ?', "%#{first}%", "%#{first}%")

		querystrings.each do |querystring|
			query = where('firstname LIKE ? OR lastname LIKE ?', "%#{querystring}%", "%#{querystring}%").or(query)
		end

		query
	end

	def admin?(project_id)
		record = projects_users.detect{ |el| el.project_id == project_id.to_i }
		record.nil? ? false : record.admin
	end
end
