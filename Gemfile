# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

gem 'aasm'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'cocoon'
gem 'devise'
gem 'foreman'
gem 'image_processing', '~> 1.2'
gem 'jbuilder', '~> 2.7'
gem 'jquery-rails'
gem 'sidekiq'
gem 'matrix'
gem 'net-smtp', require: false
gem 'pg', '~> 1.1'
gem 'prawn'
gem 'puma', '~> 5.0'
gem 'rails', '~> 6.1.6.1'
gem 'rails-controller-testing'
gem 'rails-i18n'
gem 'redis'
gem 'sass-rails', '>= 6'
gem 'simple_form'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 5.0'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'letter_opener'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'shoulda-matchers'
end

group :development do
  gem 'annotate'
  gem 'brakeman'
  gem 'bundler-audit'
  gem 'foreman'
  gem 'listen'
  gem 'rack-mini-profiler'
  gem 'spring'
  gem 'web-console'
end
