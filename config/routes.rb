Rails.application.routes.draw do
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
  
  #account_activations routes
  resources :account_activations, only: [:edit]
  
end 