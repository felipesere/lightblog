require 'sinatra/named_routes'
require 'web/tags'
require 'web/page'

module LightBlog
  class Routes < Sinatra::Application
    def initialize(app, repository)
      super(app)
      @repository = repository
    end

    register Sinatra::NamedRoutes

    map :post, '/posts/:slug'

    get '/' do
      posts = @repository.all
      page = Web::Page.new(posts, params)

      erb :index, locals: { posts: page.filter, page: page }
    end

    get :post do
      post  = @repository.find_by_slug(slug)
      newer = @repository.newer(post)
      older = @repository.older(post)
      erb :post, locals: { post: post, newer: newer, older: older}
    end

    get '/about' do
      erb :about
    end

    helpers do
      def post_url(slug)
        url :post, slug: slug
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
  end
end
