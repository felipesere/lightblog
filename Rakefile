require 'rake'
require 'rspec/core/rake_task'
require 'sass'


task :default => [:spec]

desc "Runs the specs"
RSpec::Core::RakeTask.new(:spec) do |task|
  task.fail_on_error = true
  task.verbose = false
end

namespace :assets do
  desc "Compile SCSS to CSS"
  task :compile do
    `compass compile`
  end
end
