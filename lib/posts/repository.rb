require 'posts/post'

module LightBlog
  module Posts
    class Repository
      def initialize(filesystem)
        @fs = filesystem
      end

      def all
        @all ||= @fs.all.compact.map do |raw|
          LightBlog::Posts::Post.from_raw(raw)
        end.sort_by { |post| post.raw_date }.reverse
      end

      def find_by_slug(slug)
        all.find { |post| post.slug == slug }
      end

      def newer(post)
        if all.first.title == post.title
          return nil
        end

        all.each_with_index do |current, index|
          if current.title == post.title
            return all[index-1]
          end
        end
      end

      def older(post)
        all.each_with_index do |current, index|
          if current.title == post.title
            return all[index+1]
          end
        end
      end
    end
  end
end
