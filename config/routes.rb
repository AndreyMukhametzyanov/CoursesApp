# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  concern :commentable do
    resources :comments, only: %i[create edit destroy]
  end

  root 'courses#index'

  resources :courses, concerns: :commentable do
    resources :lessons, except: :index, concerns: :commentable
    member do
      get 'promo'
      get 'start'
    end
  end
end
