Rails.application.routes.draw do
  devise_for :admins
  root 'posts#index'
  resources :posts
end
