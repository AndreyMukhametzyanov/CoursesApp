# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  concern :commentable do
    resources :comments, only: %i[create edit destroy]
  end
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root 'courses#index'

  resources :certificates, only: :index do
    member do
      post 'find'
    end
  end

  resources :courses, concerns: :commentable do
    resource :final_project do
      member do
        post 'start'
      end
      resources :replies, only: %i[create update]
    end
    resources :lessons, except: :index, concerns: :commentable do
      member do
        post 'complete'
      end
    end
    member do
      get 'promo'
      get 'start'
      post 'order'
    end
    resource :exam do
      member do
        post 'start'
      end
    end
    resources :feedbacks, only: %i[create update destroy]
  end

  resources :attachments, only: :destroy
  resources :examinations, only: :show do
    member do
      post 'check_answer'
    end
  end
end
