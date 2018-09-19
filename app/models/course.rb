class Course < ApplicationRecord
	has_many :users
	has_many :study_groups
	has_many :books

	has_and_belongs_to_many :news
end
