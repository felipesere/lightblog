require 'yaml'
require 'redcarpet'
require 'posts/markdown_renderer'
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
          markdown(remove_tag(body)).strip
        end

        def remove_tag(text)
          text.gsub(/<!-- more -->/,"")
        end

        def markdown(text)
          coderayified = LightBlog::MarkdownRenderer.new(filter_html: true, hard_wrap: true)
          options = {
            :fenced_code_blocks => true,
            :no_intra_emphasis => true,
            :autolink => true,
            :strikethrough => true,
            :lax_html_blocks => true,
            :superscript => true
          }

          markdown_to_html = Redcarpet::Markdown.new(coderayified, options)
          markdown_to_html.render(text)
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
