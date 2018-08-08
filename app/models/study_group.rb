class StudyGroup < ApplicationRecord
  belongs_to :user
  alias_attribute :owner, :user
  belongs_to :course
end
