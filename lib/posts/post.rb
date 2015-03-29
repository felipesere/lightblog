require 'yaml'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/date_time/calculations'

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
        @date = params[:date]
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
    end
  end
end
