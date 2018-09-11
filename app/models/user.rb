class User < ApplicationRecord
	has_secure_password
	validates :phone, numericality: { only_integer: true, message: 'Deve contenere solo numeri.' }
	validates :profile_picture_path, format: { with: /\A(?:\/?|\\?+[\w-]+\/?|\\?)+[.]+[a-zA-Z]+\z/, message: 'Non è valido.' }

  belongs_to :course

  has_many :study_groups

	has_many :projects_users
	has_many :all_projects, :through => :projects_users, :source => :project
  has_many :joined_projects, -> { where(projects_users: {admin: false}) }, :through => :projects_users, :source => :project, inverse_of: :members
	has_many :created_projects, -> { where(projects_users: {admin: true}) }, :through => :projects_users, :source => :project, inverse_of: :admins

	has_and_belongs_to_many :categories
end
