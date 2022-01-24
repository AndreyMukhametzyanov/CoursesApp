# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  root 'courses#index'

  resources :courses do
    resources :lessons
    member do
      get 'promo'
    end
  end
end
