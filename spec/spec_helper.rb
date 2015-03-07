require_relative '../app.rb'
require 'capybara'
require 'capybara/rspec'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end

Capybara.app = LightBlog::App

