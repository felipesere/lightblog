module LightBlog
  module Web
    class Page
      ELEMENT_TO_SHOW = 5
      def initialize(elements, page, size = ELEMENT_TO_SHOW)
        @elements = elements
        @page = page
        @size = size
      end

      def next
        if on_last_page
          nil
        else
          Page.new(elements, page+1, size)
        end
      end

      def previous
        if on_first_page
          nil
        else
          Page.new(elements, page-1, size)
        end
      end

      def filter
        elements.drop(page * size).take(size)
      end

      def url
        if on_first_page
          "/"
        else
          "/?page=#{page}"
        end
      end

      private
        attr_reader :page, :size, :elements

        def on_first_page
          page == 0
        end

        def on_last_page
          divider, rest = elements.count.divmod(size)
          if rest == 0
            page == divider -1
          else
            page == divider
          end
        end
    end
  end
end
