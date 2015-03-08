module LightBlog
  class Routes < Sinatra::Application
    get '/' do
      post = Post.new(title: 'Ripples in Abstraction',
                   subtitle: 'When things go gently wrong',
                   author: 'Felipe Sere',
                   date: 'October 23, 2014')
      erb :index, layout: true, locals: { post: post }
    end
  end

  class Post
    def initialize(params)
      @title = params[:title]
      @subtitle = params[:subtitle]
      @author = params[:author]
      @date = params[:date]
    end

    attr_reader :title, :subtitle, :author, :date
  end
end
