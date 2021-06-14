# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically
# be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

namespace :build do
  desc 'Constitutes a build on ci'
  task ci: %i[db:create db:migrate spec]

  desc 'Build locally'
  task locally: %i[db:create db:migrate spec]
end
