module LightBlog
  module Web
    class Page
      def initialize(elements, page, size)
        @elements = elements
        @page = page
        @size = size
      end

      def next
        if has_no_next
          nil
        else
          Page.new(@elements, page+1, size)
        end
      end

      def previous
        if page == 0
          nil
        else
          Page.new(@elements, page-1, size)
        end
      end

      def filter
        @elements.drop(page * size).take(size)
      end

      def url
        if page == 0
          "/"
        else
          "/?page=#{page}"
        end
      end

      private
        attr_reader :page, :size

        def has_no_next
          divider, rest = @elements.count.divmod(size)
          if rest == 0
            page == divider -1
          else
            page == divider
          end
        end
    end
  end
end
