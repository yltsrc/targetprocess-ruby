require "bundler/gem_tasks"

begin
  require 'rspec/core/rake_task'

  namespace :spec do
    desc 'Run specs that should pass'
    RSpec::Core::RakeTask.new(:ok) do |t|
      t.rspec_opts = "--tag ~wip"
      t.pattern = "./spec/**/*_spec.rb"
    end

    desc 'Run specs that are being worked on'
    RSpec::Core::RakeTask.new(:wip) do |t| # => spec_prereq
      t.rspec_opts = "--tag wip"
      t.pattern = "./spec/**/*_spec.rb"
    end

    desc 'Run all specs'
    RSpec::Core::RakeTask.new(:all) do |t|
      t.pattern = "./spec/**/*_spec.rb"
    end
  end

  desc 'Alias for spec:ok'
  task :spec => 'spec:ok'
rescue LoadError
  desc 'spec rake task not available (rspec not installed)'
  task :spec do
    abort 'Rspec rake task is not available. Be sure to install rspec as a gem or plugin'
  end
end

task :default => 'spec'
