module StoriesHelper
  def status_label(story)
    "<span class='story-status-badge #{story.status}'>#{story.status}</span>".html_safe
  end

  def status_color(story)
    return "green" if @story.approved?
    return "magenta" if @story.rejected?

    "orange"
  end

  def options_for_status_select(story, action)
    return options_for_select({"Pending" => "pending", "Approved" => "approved"}, selected: story.status) if action == "new"

    options_for_select({"Pending" => "pending", "Approved" => "approved", "Rejected" => "rejected"}, selected: story.status)
  end
end
