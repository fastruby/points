module StoriesHelper
  def status_label(story)
    if story.pending?
      return "<span class='story-status-badge'>pending</span>".html_safe
    end

    story.approved ? "<span class='story-status-badge approved'>approved</span>".html_safe : "<span class='story-status-badge rejected'>rejected</span>".html_safe
  end

  def status_string(story)
    return "pending" if story.pending?

    return "approved" if story.approved

    "rejected"
  end

  def status_color(story)
    case story.approved
    when true
      "green"
    when false
      "magenta"
    else
      "orange"
    end
  end
end
