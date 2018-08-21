Rails.application.routes.draw do
  resources :documents
  resources :projects
  resources :categories
  resources :news
  resources :study_groups
  resources :courses
  resources :users
  post 'login', :to => 'authentication#login'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
