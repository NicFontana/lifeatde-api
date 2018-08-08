Rails.application.routes.draw do
  resources :documents
  resources :project_categories
  resources :user_categories
  resources :project_users
  resources :projects
  resources :categories
  resources :project_statuses
  resources :news
  resources :study_groups
  resources :courses
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
