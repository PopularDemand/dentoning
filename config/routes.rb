Rails.application.routes.draw do
  # Password resets
  get 'password_resets/new'
  get 'password_resets/edit'

  # Static pages
  get    'help'    => 'static_pages#help'
  get    'about'   => 'static_pages#about'
  get    'contact' => 'static_pages#contact'
  root                'static_pages#home'

  # Users
  resources :users do
    member do
      get :following, :followers
    end
  end
  get    'signup'  => 'users#new'

  # Sessions
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  # Etc
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]

end