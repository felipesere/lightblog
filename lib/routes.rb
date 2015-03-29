require 'sinatra/named_routes'

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
      erb :index, locals: defaults.merge( posts: posts )
    end

    get :post do
      post = @repository.find_by_slug(params[:slug])
      erb :post, locals: defaults.merge(post: post,
                                        title: post.title,
                                        subtitle: post.subtitle)
    end

    helpers do
      def post_url(slug)
        url :post, slug: slug
      end
    end

    private
      def defaults
        {
          title: 'Code Paradoxon',
          subtitle: 'Musings on Code'
        }
      end
  end
end
