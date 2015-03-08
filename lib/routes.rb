module LightBlog
  class Routes < Sinatra::Application
    get '/' do
      post = Posts.all.first
      erb :index, locals: defaults.merge( post: post )
    end

    get '/:slug' do
      post = Posts.all.first
      erb :post, locals: defaults.merge(post: post, title: post.title)
    end

    def defaults
      { title: 'Code Paradoxon' }
    end
  end
end
