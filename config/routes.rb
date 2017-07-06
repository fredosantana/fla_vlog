Rails.application.routes.draw do
  root 'posts#index'
  get 'new', to: 'posts#new'
end
