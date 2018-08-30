class NewsSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :description
  belongs_to :course
end