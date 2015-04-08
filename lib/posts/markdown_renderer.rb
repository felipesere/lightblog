require 'redcarpet'
require 'coderay'

module LightBlog
  class MarkdownRenderer < Redcarpet::Render::HTML
    def block_code(code, language = :c)
      if language.nil?
        language = :c
      end
      CodeRay.highlight(code, language, {css: :class})
    end
  end
end
