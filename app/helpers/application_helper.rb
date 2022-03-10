module ApplicationHelper
  OPTIONS = {
    hard_wrap: true,
    link_attributes: {rel: "nofollow", target: "_blank"},
    no_intra_emphasis: true
  }.freeze

  EXTENSIONS = {
    autolink: true,
    superscript: true
  }.freeze

  def page_title_tag
    page_title = ""
    page_title += "#{@project&.parent&.title} - " if @project&.parent&.present?
    page_title += "#{@project.title} - " if @project&.title&.present?
    page_title += "Points"
    page_title
  end

  def header_link
    @project.presence || "/projects"
  end

  def header_title
    @project&.breadcrumb || "points app"
  end

  def markdown(text)
    renderer = Redcarpet::Render::HTML.new(OPTIONS)
    markdown = Redcarpet::Markdown.new(renderer, EXTENSIONS)

    markdown.render(text.to_s).html_safe
  end
end
