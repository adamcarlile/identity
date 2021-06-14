# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.0'
gem 'puma', '~> 3.11'
gem 'listen', '>= 3.0.5', '< 3.2'

gem 'doorkeeper', '~> 5.1.0'
gem 'doorkeeper-jwt'
gem 'active_model_otp'
gem 'rails_warden'
gem "transitions", require: ["transitions", "active_model/transitions"]

gem 'sprockets'
gem 'sass-rails'
gem 'jquery-rails'
gem "bulma-rails"
gem 'font-awesome-rails'
gem 'slim-rails'
gem 'builder'

gem 'virtus'
gem 'simple_form'
gem "responders"
gem "countries"
gem "pg_search"
gem "pagy"
gem 'swagger-blocks'

gem 'dotenv-rails'
gem 'lograge'
gem 'okcomputer'
gem 'pg', '~> 0.18.4'
gem "sentry-raven"

gem 'string-obfuscator'
gem 'twilio-ruby'
gem 'phonelib'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger
  # console
  gem 'pry-rails'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'committee-rails', require: false
  gem 'rspec-rails'
  gem 'ruby-debug-ide', require: false
  gem 'simplecov', require: false
  gem 'faker'
  gem 'factory_bot_rails'
end

group :development do
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem "better_errors"
  gem "binding_of_caller"
end

group :test do
  gem 'httparty'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
