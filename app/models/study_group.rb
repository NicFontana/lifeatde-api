class StudyGroup < ApplicationRecord
	validates :title, presence: { message: 'Il titolo non può essere vuoto' }
	validates :description, presence: { message: 'La descrizione non può essere vuota' }

  belongs_to :user
  belongs_to :course

  scope :matching, -> (querystring) { where('title LIKE ? OR description LIKE ?', "%#{querystring}%", "%#{querystring}%") }

	def self.with_full_infos
		includes(:course, user: [:avatar_attachment])
	end
end
