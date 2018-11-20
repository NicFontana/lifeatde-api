class UserSerializer
  include FastJsonapi::ObjectSerializer

  attributes :firstname, :lastname, :email, :bio, :birthday, :phone
  attribute :avatar, if: Proc.new { |record, params| record.association(:avatar_attachment).loaded? } do |user|
    if user.avatar.attached?
      {
        id: user.avatar.id,
        url: Rails.application.routes.url_helpers.rails_blob_url(user.avatar)
      }
    else
      {
        id: nil,
        url: "#{Rails.application.routes.default_url_options[:host]}/images/avatar.png"
      }
    end
  end

  attribute :token, if: Proc.new { |record, params| params && params[:token].present? } do |user, params|
    params[:token]
  end

  attribute :admin, if: Proc.new { |record, params| params && params[:project_id].present? && record.association(:projects_users).loaded? } do |user, params|
	  user.admin? params[:project_id]
  end

  belongs_to :course, if: Proc.new { |record, params| record.association(:course).loaded? }
  has_many :categories, if: Proc.new { |record, params| record.association(:categories).loaded? }
  has_many :projects, if: Proc.new { |record, params| record.association(:projects).loaded? }
  has_many :study_groups, if: Proc.new { |record, params| record.association(:study_groups).loaded? }
end
