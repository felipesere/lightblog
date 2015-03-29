require 'yaml'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/date_time/calculations'
require 'active_support/core_ext/object/blank'

module LightBlog
  module Posts
    class Post
      def self.from_raw(raw)
        params = HashWithIndifferentAccess.new YAML.load(raw)
        params[:content] = extract_content(raw)
        new(params)
      end

      def initialize(params)
        @params = params
        @title = params[:title]
        @subtitle = params[:subtitle]
        @content = params[:content]
        @author = params[:author]
        @date = format_date
        @slug = extract_slug
      end

      def snippet(size=25)
        "#{words(size).rstrip}..."
      end

      def words(size)
        content.scan(/\S+/).take(size).join(" ")
      end

      attr_reader :title, :content, :subtitle, :author, :date, :slug

      private
        def self.extract_content(raw)
          raw.gsub(/---.+---/m," ").lstrip
        end

        def extract_slug
          @params[:slug] || generate_slug
        end

        def generate_slug
          @params.fetch(:title).downcase.gsub(/\s+/,'-')
        end

        def format_date
          if @params[:date].present?
            @params[:date].strftime("%B %e, %Y")
          end
        end
    end
  end
end
