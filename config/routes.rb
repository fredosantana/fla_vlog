Rails.application.routes.draw do
  devise_for :admins
  root 'posts#index'
  resources :posts, only: [:new, :create, :show, :edit, :update]
end
