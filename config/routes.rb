# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  devise_scope :users do
    get '/users/created_courses', to: 'users_accounts#created_courses'
    get '/users/certificates', to: 'users_accounts#certificates'
    get '/users/studied_courses', to: 'users_accounts#studied_courses'
    get '/users/students_reply', to: 'users_accounts#students_reply'
  end

  concern :commentable do
    resources :comments, only: %i[create edit destroy]
  end
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  root 'courses#index'

  resources :certificates, only: [:index] do
    collection do
      get 'check_certificate'
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
      post 'change_state'
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
