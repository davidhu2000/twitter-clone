Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

  get 'account_activations/edit'

  root 'static_pages#home'
  
  #static_pages_controller routes
  get 'help'    => 'static_pages#help'
  get 'about'   => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  
  #users_controller routes 
  get 'signup'  => 'users#new'
  resources :users, except: [:new]
  
  #sessions_controller routes
  get    'login'  => 'sessions#new'
  post   'login'  => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  
  #account_activations and password_resets routes
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  
  resources :microposts,          only: [:create, :destroy]
  
end 