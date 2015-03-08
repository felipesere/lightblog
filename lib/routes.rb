module LightBlog
  class Routes < Sinatra::Application
    get '/' do
      posts = Posts.all
      erb :index, locals: defaults.merge( posts: posts )
    end

    get '/:slug' do
      slug = params.fetch("slug")
      post = Posts.find_by_slug(slug)
      erb :post, locals: defaults.merge(post: post,
                                        title: post.title,
                                        subtitle: post.subtitle)
    end

    def defaults
      { title: 'Code Paradoxon',
        subtitle: 'Musings on Code'}
    end
  end
end
