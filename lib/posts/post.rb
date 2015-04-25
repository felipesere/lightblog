require 'yaml'
require 'posts/markdown/renderer'
require 'posts/text'
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
        @author = params[:author]
        @date = format_date
        @slug = extract_slug
        @text = Text.new(body)
      end

      def snippet(size=25)
        @text.snippet(size)
      end

      def content
        @text.content
      end

      attr_reader :title, :author, :date, :slug

      private
        def body
         @params[:raw].gsub(/---.+---/m,"").lstrip
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
