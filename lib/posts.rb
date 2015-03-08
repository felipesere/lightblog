module LightBlog
  class Posts
    def self.create(params)
      @new_post = Post.new(params)
    end

    def self.all
      [@new_post]
    end
  end

  class Post
    def initialize(params)
      @title = params[:title]
      @subtitle = params[:subtitle]
      @author = params[:author]
      @date = params[:date]
      @slug = params[:slug]
    end

    attr_reader :title, :subtitle, :author, :date, :slug
  end
end
