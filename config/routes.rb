Rails.application.routes.draw do
  scope :api do

    post 'login', :to => 'authentication#login'

    get 'users', :to => 'users#search'
    resources :users, only: [:show, :update] do
      get 'projects', :to => 'projects#user_projects'
      get 'study_groups', :to => 'study_groups#user_study_groups'
      get 'books', :to => 'books#user_books'
      delete 'avatar', :to => 'user#avatar_destroy'
    end

    resources :projects do
      get 'members', :to => 'users#members_index'
      post 'members', :to => 'users#members_add'
      delete 'members', :to => 'users#members_destroy'
      delete 'documents', :to => 'projects#documents_destroy'
    end

    resources :categories, only: [:index, :show] do
      get 'projects', :to => 'projects#category_projects'
    end

		resources :courses, only: [:index, :show] do
			resources :study_groups, shallow: true
			resources :books, shallow: true
			resources :news, only: [:show, :index]
    end

		get 'study_groups', :to => 'study_groups#search'

    get 'books', :to => 'books#search'
    delete 'books/:id/photos', :to => 'books#photos_destroy'
  end
end
