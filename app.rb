require 'sinatra'
require 'sinatra/content_for'
require './lib/routes'
require './lib/posts'

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

    use LightBlog::Routes

    LightBlog::Posts.create(title: 'Ripples in Abstraction',
                   subtitle: 'When things go gently wrong',
                   author: 'Felipe Sere',
                   date: 'October 23, 2014',
                   slug: 'ripples-in-abstraction');
  end
end
