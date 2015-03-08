module LightBlog
  class Posts
    def self.create(params)
      @posts ||= []
      @posts << Post.new(params)
    end

    def self.all
      @posts
    end

    def self.find_by_slug(slug)
      @posts.first
    end

    def self.clear
      @posts = []
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
