require 'posts/post'

module LightBlog
  module Posts
    class Repository
      def initialize(filesystem)
        @fs = filesystem
      end

      def all
        @fs.all.compact.map do |raw|
          LightBlog::Posts::Post.from_raw(raw)
        end.sort_by { |post| post.date }
      end

      def find_by_slug(slug)
        all.find { |post| post.slug == slug }
      end

      private
    end
  end
end
