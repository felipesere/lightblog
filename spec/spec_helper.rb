$:.unshift(File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib'))

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end
