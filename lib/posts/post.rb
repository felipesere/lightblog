require 'yaml'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/date_time/calculations'
require 'active_support/core_ext/object/blank'

module LightBlog
  module Posts
    class Post
      def self.from_raw(raw)
        params = HashWithIndifferentAccess.new YAML.load(raw)
        new(params)
      end

      def initialize(params)
        @params = params
        @title = params[:title]
        @subtitle = params[:subtitle]
        @author = params[:author]
        @date = format_date
        @slug = extract_slug
      end

      attr_reader :title, :subtitle, :author, :date, :slug

      private
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
