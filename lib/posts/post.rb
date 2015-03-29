require 'yaml'
require 'kramdown'
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
        @content = extract_content
        @author = params[:author]
        @date = format_date
        @slug = extract_slug
      end

      def snippet(size=25)
        markdown(extract_snippet(size) + "...").rstrip
      end

      attr_reader :title, :content, :subtitle, :author, :date, :slug

      private
        def extract_content
          markdown(body)
        end

        def markdown(text)
          Kramdown::Document.new(text, auto_ids: false, 
                                       syntax_highlighter: 'coderay',
                                       syntax_highlighter_opts: { line_numbers: false,
                                                                  css: :class} ).to_html
        end

        def body
          @params[:raw].gsub(/---.+---/m,"").lstrip
        end

        def extract_snippet(size)
          if has_marker?
            body[/(.+)<!-- more -->.*/m, 1].strip
          else
            body.scan(/\S+/).take(size).join(" ")
          end
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
          if @params[:date].present?
            @params[:date].strftime("%B %e, %Y")
          end
        end
    end
  end
end
