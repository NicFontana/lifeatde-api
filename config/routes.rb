Rails.application.routes.draw do
  scope :api do
    resources :projects do
      delete 'documents', :to => 'projects#documents_destroy'
      get 'members', :to => 'users#members_index'
      post 'members', :to => 'users#members_create'
      delete 'members', :to => 'users#members_destroy'
    end
    resources :categories, only: [:index, :show] do
      get 'projects', :to => 'projects#category_projects'
    end
		resources :courses, only: [:index, :show] do
			resources :study_groups, shallow: true
			resources :books, shallow: true
			resources :news, only: [:show]
			get 'news', :to => 'news#course_news'
		end
		get 'study_groups', :to => 'study_groups#search'
    get 'books', :to => 'books#search'
    get 'users', :to => 'users#search_users'
		resources :users do
      collection do
        get :me
      end
      delete 'avatar', :to => 'user#avatar_destroy'
      get 'projects', :to => 'projects#user_projects'
    end
    post 'login', :to => 'authentication#login'
  end
end
