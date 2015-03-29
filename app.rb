$:.unshift(File.join(File.expand_path(File.dirname(__FILE__)), 'lib'))

require 'sinatra'
require 'sinatra/content_for'
require 'routes'
require 'filesystem'
require 'posts/repository'

module LightBlog
  class App < Sinatra::Application

    Tilt.register Tilt::ERBTemplate, 'html.erb'

    configure do
      disable :method_override
      set :erb, :escape_html => true,
                :static => true,
                :public_folder => 'public'

      set :partial_template_engine, :erb
    end

    fs = LightBlog::Filesystem.new("./posts")
    repo = LightBlog::Posts::Repository.new(fs)
    use  LightBlog::Routes, repo

  end
end
