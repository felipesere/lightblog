require 'rake'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'
require 'sass'


task :default => 'spec'

desc 'Run RuboCop on the lib directory'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = ['lib/**/*.rb']
  # only show the files with failures
  task.formatters = ['clang']
  # don't abort rake on failure
  task.fail_on_error = true
end

desc "Runs the specs"
RSpec::Core::RakeTask.new(:spec) do |task|
  task.fail_on_error = true
  task.verbose = false
end
