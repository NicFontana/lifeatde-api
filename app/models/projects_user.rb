class ProjectsUser < ApplicationRecord
  belongs_to :project
  belongs_to :user

  scope :admin, -> { where('admin == true')}
end
