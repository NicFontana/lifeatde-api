class StudyGroup < ApplicationRecord
  belongs_to :user
  #alias_attribute :owner, :user
  belongs_to :course

  def self.for_user(user)
	  where(course_id: user.course.id)
  end
end
