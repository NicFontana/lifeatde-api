Rails.application.routes.draw do
  scope :api do
    resources :documents
    resources :projects do
      get 'members', :to => 'users#members_index'
      post 'members', :to => 'users#members_create'
      delete 'members', :to => 'users#members_destroy'
    end
    resources :categories do
      get 'projects', :to => 'projects#category_projects'
    end
		resources :courses do
			resources :study_groups, shallow: true
			resources :news, only: [:show]
			get 'news', :to => 'news#course_news'
		end
		get 'study_groups', :to => 'study_groups#search'
		resources :users do
      get 'projects', :to => 'projects#user_projects'
    end
    post 'login', :to => 'authentication#login'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
