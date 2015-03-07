require 'sinatra'
require 'sinatra/content_for'
require './lib/index/show'

module LightBlog
  class App < Sinatra::Application

    Tilt.register Tilt::ERBTemplate, 'html.erb'

    configure do
      disable :method_override
      set :erb, escape_html: true
    end

    use Index::Show
  end
end
