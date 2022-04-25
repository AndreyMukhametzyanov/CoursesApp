# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  concern :commentable do
    resources :comments, only: %i[create edit destroy]
  end

  root 'courses#index'

  resources :courses, concerns: :commentable do
    resource :exam
    resources :lessons, except: :index, concerns: :commentable
    member do
      get 'promo'
      get 'start'
      post 'order'
    end
  end
  resources :attachments, only: :destroy
end
