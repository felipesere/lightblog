module LightBlog
  class Routes < Sinatra::Application
    def initialize(app, repository)
      super(app)
      @repository = repository
    end

    get '/' do
      posts = @repository.all
      erb :index, locals: defaults.merge( posts: posts )
    end

    get '/posts/:slug' do
      post = @repository.find_by_slug(params[:slug])
      erb :post, locals: defaults.merge(post: post,
                                        title: post.title,
                                        subtitle: post.subtitle)
    end

    def defaults
      {
        title: 'Code Paradoxon',
        subtitle: 'Musings on Code'
      }
    end
  end
end
