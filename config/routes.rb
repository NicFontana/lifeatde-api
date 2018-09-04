Rails.application.routes.draw do
  resources :documents
  resources :projects
  resources :categories
  resources :news
  resources :study_groups
  resources :courses do
    resources :news
    # 'news', :to => 'courses#get_news_for_course'
  end
  resources :users
  post 'login', :to => 'authentication#login'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
