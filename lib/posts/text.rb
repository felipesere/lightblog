require 'posts/markdown/renderer'

module LightBlog
  module Posts
    class Text
      def initialize(raw)
        @raw = raw
      end

      def snippet(size=25)
        markdown(extract_snippet(size) + "...").rstrip
      end

      def content
        markdown(wihtout_marker(body)).strip
      end

      private
        def wihtout_marker(text)
          text.gsub(/<!-- more -->/,"")
        end

        def markdown(text)
          renderer = LightBlog::Markdown::Renderer.new
          renderer.markdown(text)
        end

        def extract_snippet(size)
          if has_marker?
            up_to_words(up_to_marker, size)
          else
            up_to_words(body, size)
          end
        end

        def up_to_marker
          body[/(.+)<!-- more -->.*/m, 1].strip
        end

        def up_to_words(body, size)
          body.scan(/\S+/).take(size).join(" ")
        end

        def has_marker?
          body.include?("<!-- more -->")
        end

        def body
          @raw
        end
    end
  end
end
