module ProjectsHelper
  def estimated(story)
    @estimate_id = story.estimate_for(current_user)
    @estimate_id.present?
  end

  def link_unless_archived(project, text, url, color: nil, method: :get, remote: false, icon: nil, data_attr: nil)
    if project.archived? || project.parent&.archived?
      button_tag(text, disabled: true, class: "button #{color} disabled", aria: {disabled: true})
    else
      if icon
        icon_tag = content_tag(:i, "", class: "fa fa-#{icon}").concat(content_tag(:span, text))
      end
      link_to(icon_tag || text, url, class: "button #{color}", title: text, method: method, remote: remote, data: data_attr)
    end
  end
end
