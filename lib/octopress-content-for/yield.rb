# Inspired by jekyll-contentblocks https://github.com/rustygeldmacher/jekyll-contentblocks
#
module Octopress
  module Tags
    module Yield
      class Tag < Liquid::Tag

        def initialize(tag_name, markup, tokens)
          if markup.strip == ''
            raise IOError.new "Yield failed: {% #{tag_name} #{markup}%}. Please provide a block name to yield. - Syntax: {% yield block_name %}"
          end

          super
          @markup = markup
          if markup =~ TagHelpers::Var::HAS_FILTERS
            markup = $1
            @filters = $2
          end
          @block_name = TagHelpers::ContentFor.get_block_name(tag_name, markup)
        end

        def render(context)
          return unless markup = TagHelpers::Conditional.parse(@markup, context)
          content = TagHelpers::ContentFor.render(context, @block_name)

          unless content.nil? || @filters.nil?
            content = TagHelpers::Var.render_filters(content, @filters, context)
          end

          content
        end
      end
    end
  end
end
