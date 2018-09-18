class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :firstname, :lastname, :email, :bio, :birthday, :phone, :profile_picture_path

  has_many :projects, if: Proc.new { |record, params| record.association(:projects).loaded? }
  has_many :study_groups, if: Proc.new { |record, params| record.association(:study_groups).loaded? }

  attribute :admin, if: Proc.new { |record, params| params && params[:project_id].present? && record.association(:projects_users).loaded? } do |user, params|
    user.admin? params[:project_id]
  end

  attribute :course, if: Proc.new { |record, params| record.association(:course).loaded? } do |user, params|
    {id: user.course.id, name: user.course.name }
  end

  attribute :categories, if: Proc.new { |record, params| record.association(:categories).loaded? } do |user, params|
    categories = []
    user.categories.each do |category|
      categories << {id: category.id, name: category.name}
    end
    categories
  end
end
