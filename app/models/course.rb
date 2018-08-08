class Course < ApplicationRecord
	has_many :users
	has_many :study_groups
	has_many :news
end
