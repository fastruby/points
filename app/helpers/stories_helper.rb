module StoriesHelper
  def status_label(story)
    "<span class='story-status-badge #{story.status}'>#{story.status}</span>".html_safe
  end

  def status_color(story)
    return "green" if @story.approved?

    return "magenta" if @story.rejected?

    return "orange" if @story.pending?
  end
end
