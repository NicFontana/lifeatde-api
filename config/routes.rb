Rails.application.routes.draw do
	scope :api do
		resources :documents
		resources :projects
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
      get 'projects/open', :to => 'projects#user_open_projects'
			get 'projects/closed', :to => 'projects#user_closed_projects'
			get 'projects/terminated', :to => 'projects#user_open_projects'
    end
		post 'login', :to => 'authentication#login'
	end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
