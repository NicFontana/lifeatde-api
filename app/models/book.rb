class Book < ApplicationRecord
  validates :title, presence: { message: 'Il titolo non può essere vuoto' }
  validates :price,
            presence: { message: 'Il prezzo non può essere vuoto' },
            format: { with: /\A\d+(?:\.\d{0,2})?\z/, message: 'Il prezzo deve essere nel formato \'xx.xx\'' },
            numericality: { greater_than_or_equal_to: 0, less_than: 10000000, message: 'Il prezzo deve essere compreso tra 0 e 10 milioni' }
  belongs_to :user
  belongs_to :course

  has_many_attached :photos

  scope :matching, -> (querystring) {where('title LIKE ? OR description LIKE ?', "%#{querystring}%", "%#{querystring}%")}

  def self.with_full_infos
    includes(:course, user: [:avatar_attachment]).with_attached_photos
  end
end
