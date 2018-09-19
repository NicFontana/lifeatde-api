class Book < ApplicationRecord
  belongs_to :user
  belongs_to :course

  scope :matching, -> (querystring) {where('title LIKE ? OR description LIKE ?', "%#{querystring}%", "%#{querystring}%")}
end
