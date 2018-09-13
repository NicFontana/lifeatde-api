class ProjectsUser < ApplicationRecord
  belongs_to :project
  belongs_to :user

  scope :is_admin, -> { where('admin == true')}
end
