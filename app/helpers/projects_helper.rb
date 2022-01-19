module ProjectsHelper
  def estimated(story)
    @estimate_id = story.estimate_for(current_user)
    @estimate_id.present?
  end

  def link_unless_archived(project, text, url, color: nil, method: :get, remote: false)
    if project.archived?
      button_tag(text, disabled: true, class: "button #{color} disabled", aria: {disabled: true}, remote: remote)
    else
      link_to(text, url, class: "button #{color}", method: method)
    end
  end
end
