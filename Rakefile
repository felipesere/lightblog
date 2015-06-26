require 'rake'
require 'rspec/core/rake_task'
require 'sass'


task :default => [:spec]

desc "Runs the specs"
RSpec::Core::RakeTask.new(:spec) do |task|
  task.fail_on_error = true
  task.verbose = false
end

desc "Run the server in background"
task :server do
  conf = File.expand_path('config.ru', File.dirname(__FILE__))
  exec("thin -p 9292 -R #{conf} -e #{ENV['RACK_ENV']} -d --log log/access.log start")
end

desc "Run the server in background"
task :stop_server do
  file = "tmp/pids/thin.pid"
  if File.exist?(file)
    pid = File.read(file)
    File.delete(file)
    puts "Stopped server with pid #{pid}"
    exec("kill -s kill #{pid}")
  else
    puts "Server not running"
  end
end

namespace :assets do
  desc "Compile SCSS to CSS"
  task :compile do
    `compass compile`
  end
end
