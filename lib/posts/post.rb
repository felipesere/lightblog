require 'yaml'
require 'posts/markdown/renderer'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/date_time/calculations'
require 'active_support/core_ext/object/blank'

module LightBlog
  module Posts
    class Post
      def self.from_raw(raw)
        params = HashWithIndifferentAccess.new YAML.load(raw)
        params[:raw] = raw
        new(params)
      end

      def initialize(params)
        @params = params
        @title = params[:title]
        @subtitle = params[:subtitle]
        @author = params[:author]
        @content = extract_content
        @date = format_date
        @slug = extract_slug
      end

      def snippet(size=25)
        markdown(extract_snippet(size) + "...").rstrip
      end

      attr_reader :title, :content, :subtitle, :author, :date, :slug

      private
        def extract_content
          markdown(wihtout_marker(body)).strip
        end

        def wihtout_marker(text)
          text.gsub(/<!-- more -->/,"")
        end

        def markdown(text)
          renderer = LightBlog::Markdown::Renderer.new
          renderer.markdown(text)
        end

        def body
         @params[:raw].gsub(/---.+---/m,"").lstrip
        end

        def extract_snippet(size)
          if has_marker?
            up_to_marker
          else
            up_to_words(size)
          end
        end

        def up_to_marker
            body[/(.+)<!-- more -->.*/m, 1].strip
        end

        def up_to_words(size)
          body.scan(/\S+/).take(size).join(" ")
        end

        def has_marker?
          body.include?("<!-- more -->")
        end

        def extract_slug
          @params[:slug] || generate_slug
        end

        def generate_slug
          @params.fetch(:title).downcase.gsub(/\s+/,'-')
        end

        def format_date
          if has_date?
            @params[:date].strftime("%B %e, %Y")
          end
        end

        def has_date?
          @params[:date].present?
        end
    end
  end
end
