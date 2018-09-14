Rails.application.routes.draw do
	scope :api do
		resources :documents
		resources :projects do
			get 'members', :to => 'users#members_index'
			post 'members', :to => 'users#members_create'
			delete 'members/:id', :to => 'users#members_destroy'
		end
    resources :categories do
      get 'projects', :to => 'projects#category_projects'
    end
		resources :study_groups
		resources :courses do
			resources :news, only: [:show]
			get 'news', :to => 'news#course_news'
		end
		resources :users do
      get 'projects', :to => 'projects#user_projects'
			get 'joined_projects', :to => 'projects#joined_projects_index'
			post 'joined_projects', :to => 'projects#joined_projects_create'
			delete 'joined_projects/:id', :to => 'projects#joined_projects_destroy'
    end
		post 'login', :to => 'authentication#login'
	end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
