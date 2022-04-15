Rails.application.routes.draw do
  get 'welcome/index'
  namespace :api do
    namespace :v1 do
      resources :records
      resources :artists

    end
  end

  root "welcome#index"


  post "refresh", controller: :refresh, action: :create
  post "login", controller: :login, action: :create
  post "signup", controller: :signup, action: :create
  delete "login", controller: :login, action: :destroy


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
