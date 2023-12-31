# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
                                 sign_in: 'login',
                                 sign_out: 'logout'
                               },
                     controllers: {
                       sessions: 'users/sessions'
                     }

  resources :comments
  resources :posts
  resources :users
end
