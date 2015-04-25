require 'redcarpet'
require 'coderay'

module LightBlog
  module Markdown
    class Renderer
      def markdown(text)
        coderayified = CodeHighlighter.new(filter_html: true, hard_wrap: true)

        markdown_to_html = Redcarpet::Markdown.new(coderayified, options)
        markdown_to_html.render(text)
      end

      def options
        {
          :fenced_code_blocks => true,
          :no_intra_emphasis => true,
          :autolink => true,
          :strikethrough => true,
          :lax_html_blocks => true,
          :superscript => true
        }
      end

    end

    class CodeHighlighter < Redcarpet::Render::HTML
      def block_code(code, language = :c)
        if language.nil?
          language = :c
        end
        CodeRay.highlight(code, language, {css: :class})
      end

 #     def paragraph(text)
 #       "<p data-section-id=\"1\" class=\"commentable-section\">#{text}</p>"
 #     end
    end
  end
end
