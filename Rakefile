# frozen_string_literal: true
require 'bundler/setup'
require 'bundler/gem_tasks'
require 'bump/tasks'
require "rspec/core/rake_task"

task default: ["spec", "rubocop"]

RSpec::Core::RakeTask.new(:spec)

desc "Run rubocop"
task :rubocop do
  sh "rubocop --parallel"
end

begin
  require "duel/rake_task"
  Duel::RakeTask.new
rescue LoadError
  # Duel requires Ruby 3.4 or later
end
