module ApplicationHelper

    def markdown(text)
      options = {
        filter_html:     true,
        hard_wrap:       true,
        link_attributes: { rel: 'nofollow', target: "_blank" },
        fenced_code_blocks: true,
        no_intra_emphasis:  true,
      }

      extensions = {
        autolink:           true,
        superscript:        true,
      }

      renderer = Redcarpet::Render::HTML.new(options)
      markdown = Redcarpet::Markdown.new(renderer, extensions)

      markdown.render(text).html_safe
  end

end
