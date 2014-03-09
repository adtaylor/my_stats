MyStats::Application.routes.draw do
  resources :notifications

  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations", omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :users
  resources :app do
    resources :notifications
  end
end
