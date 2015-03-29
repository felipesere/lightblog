require 'posts/post'

module LightBlog
  module Posts
    class Repository
      def initialize(filesystem)
        @fs = filesystem
      end

      def all
        @fs.all.map do |raw|
          if raw.nil?
          else
            LightBlog::Posts::Post.from_raw(raw)
          end
        end
      end

      def find_by_slug(slug)
        all.find { |post| post.slug == slug }
      end
    end
  end
end
