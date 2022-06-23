# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do
    concern :commentable do
      resources :comments, only: %i[create edit destroy]
    end

    root 'courses#index'

    resources :courses, concerns: :commentable do
      resources :lessons, except: :index, concerns: :commentable
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
end
