# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

gem 'aasm'
gem 'bootsnap', require: false
gem 'cocoon'
gem 'devise'
gem 'image_processing'
gem 'jbuilder'
gem 'jquery-rails'
gem 'matrix'
gem 'net-smtp', require: false
gem 'pg'
gem 'prawn'
gem 'prawn-svg'
gem 'puma'
gem 'rails'
gem 'rails-controller-testing'
gem 'rails-i18n'
gem 'redis'
gem 'rqrcode'
gem 'sass-rails'
gem 'sidekiq'
gem 'simple_form'
gem 'turbolinks'
gem 'webpacker'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'foreman'
  gem 'letter_opener'
  gem 'letter_opener_web'
  gem 'rspec-rails'
  gem 'rspec-sidekiq', require: false
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
end

group :development do
  gem 'annotate'
  gem 'brakeman'
  gem 'bundler-audit'
  gem 'listen'
  gem 'rack-mini-profiler'
  gem 'spring'
  gem 'web-console'
end
