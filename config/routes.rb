Rails.application.routes.draw do
  
  root 'static_pages#home'

  get '/enroll/:id', to: 'events#enroll', as: :enroll

  get '/about', to: 'static_pages#about', as: :about
  
  get '/contact', to: 'static_pages#contact', as: :contact

  get 'vote/:id', to: 'answers#vote', as: :vote
  
  resources :charges

  get '/learn', to: 'static_pages#learn', as: :learn

  devise_for :users, :controllers => { registrations: 'registrations', omniauth_callbacks: "omniauth_callbacks" }
  
  resources :users, only: [:index, :show]

  match 'users/:id' => 'users#destroy', :via => :delete, :as => :admin_destroy_user

  get '/edit_admin/:id', to: 'users#edit_admin', as: :edit_admin

  patch '/upd_admin/:id', to: 'users#upd_admin', as: :upd_admin

  get '/admin/:id', to: 'users#admin', as: :admin

  resources :questions do
    resources :answers #only: [:index, :show, :new, :create, :edit, :update, :destroy]
  end
  
  resources :events #only: [:index, :show, :new, :create, :edit, :update, :destroy]
end
