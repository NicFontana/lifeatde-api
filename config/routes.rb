Rails.application.routes.draw do
	scope :api do
		resources :documents
		resources :projects
    get 'pippo/:user_id', :to => 'projects#user_projects'
		resources :categories
		resources :study_groups
		resources :courses do
			resources :news, only: [:show]
			get 'news', :to => 'news#course_news'
		end
		resources :users
		post 'login', :to => 'authentication#login'
	end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
