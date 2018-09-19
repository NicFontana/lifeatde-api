class BookSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :description, :price

  belongs_to :user, if: Proc.new { |record, params| record.association(:user).loaded? }

  attribute :course, if: Proc.new { |record, params| record.association(:course).loaded? } do |book, params|
    book.course.name
  end
end
