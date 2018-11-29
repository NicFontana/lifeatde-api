class StudyGroup < ApplicationRecord
	validates :title, presence: { message: 'Questo campo non può essere vuoto' }
	validates :description, presence: { message: 'Questo campo non può essere vuoto' }

  belongs_to :user
  belongs_to :course

  scope :matching, -> (querystring) { where('title LIKE ? OR description LIKE ?', "%#{querystring}%", "%#{querystring}%") }

	def self.with_full_infos
		includes(:course, user: [:avatar_attachment])
	end
end
