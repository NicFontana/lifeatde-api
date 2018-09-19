class NewsSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :description, :created_at
end