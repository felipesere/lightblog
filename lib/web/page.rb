module LightBlog
  module Web
    class Page
      def initialize(elements, params)
        @params = params
        @elements = elements
      end

      def next
        if has_no_next
          nil
        else
          Page.new(@elements, @params.merge({"page" => page+1}))
        end
      end

      def previous
        if page == 0
          nil
        else
          Page.new(@elements, @params.merge({"page" => page-1}))
        end
      end

      def filter
        @elements.drop(page*size).take(size)
      end

      def url
        if page == 0
          "/"
        else
          "/?page=#{page}&size=#{size}"
        end
      end

      private
        def page
          @params.fetch("page", 0).to_i
        end

        def size
          @params.fetch("size", 2).to_i
        end

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
