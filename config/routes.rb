Rails.application.routes.draw do
  scope :api do
    resources :documents
    resources :projects do
      get 'members', :to => 'users#members_index'
      post 'members', :to => 'users#members_create'
      delete 'members', :to => 'users#members_destroy'
      get 'members/find', :to => 'users#find_members_for_project'
    end
    resources :categories, only: [:index, :show] do
      get 'projects', :to => 'projects#category_projects'
    end
		resources :courses, only: [:index, :show] do
			resources :study_groups, shallow: true
			resources :news, only: [:show]
			get 'news', :to => 'news#course_news'
		end
		get 'study_groups', :to => 'study_groups#search'
    get 'users/me', :to => 'users#auth_user_informations'
		resources :users do
      get 'projects', :to => 'projects#user_projects'
    end
    post 'login', :to => 'authentication#login'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
