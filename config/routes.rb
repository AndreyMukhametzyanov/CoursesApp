# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  root 'courses#index'

  resources :courses do
    resources :lessons, except: :index
    member do
      get 'promo'
      get 'start'
    end
  end
end
