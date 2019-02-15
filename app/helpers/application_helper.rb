module ApplicationHelper

  OPTIONS = {
    filter_html:     true,
    hard_wrap:       true,
    link_attributes: { rel: 'nofollow', target: "_blank" },
    fenced_code_blocks: true,
    no_intra_emphasis:  true,
  }.freeze

  EXTENSIONS = {
    autolink:           true,
    superscript:        true,
  }.freeze

  def markdown(text)

    renderer = Redcarpet::Render::HTML.new(OPTIONS)
    markdown = Redcarpet::Markdown.new(renderer, EXTENSIONS)

    markdown.render(text).html_safe
  end

end
