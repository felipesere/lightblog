module LightBlog
  module Web
    class Tags
      def css(*names)
        names.map do |name|
          "<link rel=\"stylesheet\" href=\"/css/#{name}.css\">"
        end.join("\n")
      end

      def js(*names)
        names.map do |name|
          "<script src=\"/js/#{name}.js\" type=\"text/javascript\"></script>"
        end.join("\n")
      end

      def image(names, options = {})
        if names.respond_to? :map
          create_multiple_tags(names, options)
        else
          create_tag(names, options)
        end
      end

      private
      def create_tag(name, options)
        "<img src=\"/images/#{name}\"#{attributes(options)}/>"
      end

      def create_multiple_tags(names, options)
        names.map do |name|
          create_tag(name, options)
        end.join("\n")
      end

      def attributes(options)
        classes(options)+alt(options)
      end

      def classes(options)
        classes = options[:class]
        if classes
          " class=\"#{classes.join(" ")}\""
        else
          ""
        end
      end

      def alt(options)
        alt = options[:alt]
        if alt
          " alt=\"#{alt}\""
        else
          ""
        end
      end
    end
  end
end
