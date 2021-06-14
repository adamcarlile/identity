# frozen_string_literal: true

if ENV['RAILS_ENV'] != 'production' && defined? Rspec
  namespace :test do
    desc 'Runs the smoke tests to test app deployment'
    RSpec::Core::RakeTask.new(:smoke) do |task|
      task.rspec_opts = '--tag smoke --pattern spec/smoke/**/*.rb spec/support/shared_*.rb spec/support/smoke_*.rb'
    end
  end
end
