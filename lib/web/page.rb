module LightBlog
  module Web
    class Page
      def initialize(count, params)
        @params = params
        @count = count
      end

      def next
        return nil if has_no_next
        Page.new(@count, @params.merge({"page" => page+1}))
      end

      def previous
        return nil if page == 0
        Page.new(@count, @params.merge({"page" => page-1}))
      end

      def filter(elements)
        elements.drop(page*size).take(size)
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
          divider, rest = @count.divmod(size)
          if rest == 0
            page == divider -1
          else
            page == divider
          end
        end
    end
  end
end
