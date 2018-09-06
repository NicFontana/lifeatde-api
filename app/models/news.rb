class News < ApplicationRecord
  has_and_belongs_to_many :courses

  def self.course_news(course_id)
    left_outer_joins(:courses).where('courses.id = ? OR courses.id IS NULL',course_id)
  end
end
