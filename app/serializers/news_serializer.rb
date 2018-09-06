class NewsSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :description
end