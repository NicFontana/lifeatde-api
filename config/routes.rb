Rails.application.routes.draw do
	scope 'api' do
		resources :documents
		resources :projects
		resources :categories
		resources :news
		resources :study_groups
		resources :courses
		resources :users, only: [:index, :show, :update, :destroy]
		post 'login', :to => 'authentication#login'
	end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
