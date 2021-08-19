module ApplicationHelper
  OPTIONS = {
    filter_html: true,
    link_attributes: {rel: "nofollow", target: "_blank"},
    no_intra_emphasis: true
  }.freeze

  EXTENSIONS = {
    autolink: true,
    superscript: true
  }.freeze

  def markdown(text)
    renderer = Redcarpet::Render::HTML.new(OPTIONS)
    markdown = Redcarpet::Markdown.new(renderer, EXTENSIONS)

    markdown.render(text.to_s).html_safe
  end
end
