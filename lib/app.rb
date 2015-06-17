Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

require 'sinatra'
require 'sinatra/content_for'
require 'sinatra/named_routes'
require 'sinatra/config_file'

require 'posts/repository'
require 'filesystem'
require 'web/tags'
require 'web/page'

module LightBlog
  class App < Sinatra::Application
    register Sinatra::NamedRoutes
    register Sinatra::ConfigFile

    config_file '../config/application.yml'

    configure do
      disable :method_override
      set :views, Proc.new { File.join(root, "../views") }
      set :public_folder, Proc.new { File.join(root, "../public") }
    end

    map :post, '/posts/:slug'

    get '/' do
      posts = repository.all
      current_page = Web::Page.new(posts, page)

      erb :index, locals: { posts: current_page.filter, page: current_page }
    end

    get :post do
      post  = repository.find_by_slug(slug)
      if post
        newer = repository.newer(post)
        older = repository.older(post)
        erb :post, locals: { post: post, newer: newer, older: older}
      else
        erb :not_found
      end
    end

    get '/about' do
      erb :about
    end

    get '*' do
      erb :not_found
    end

    helpers do
      def post_url(slug)
        url :post, false, slug: slug
      end

      def css_tag(*names)
        tags.css(*names)
      end

      def js_tag(*names)
        tags.js(*names)
      end

      def image_tag(names, options={})
        tags.image(names, options)
      end
    end

    private
      def tags
        Web::Tags.new
      end

      def slug
        params[:slug]
      end

      def page
        @params.fetch("page", 0).to_i
      end

      def repository
        @repository ||= LightBlog::Posts::Repository.new(fs)
      end

      def fs
        LightBlog::Filesystem.new(settings.posts)
      end
  end
end
