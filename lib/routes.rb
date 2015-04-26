require 'sinatra/named_routes'
require 'web/tags'
require 'web/page'

module LightBlog
  class Routes < Sinatra::Application
    POST_PER_PAGE = 5
    def initialize(app, repository)
      super(app)
      @repository = repository
    end

    register Sinatra::NamedRoutes

    map :post, '/posts/:slug'

    get '/' do
      posts = @repository.all
      current_page = Web::Page.new(posts, page, POST_PER_PAGE)

      erb :index, locals: { posts: current_page.filter, page: current_page }
    end

    get :post do
      post  = @repository.find_by_slug(slug)
      if post
        newer = @repository.newer(post)
        older = @repository.older(post)
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

      def page
        @params.fetch("page", 0).to_i
      end
  end
end
