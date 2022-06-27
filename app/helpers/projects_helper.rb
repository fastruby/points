module ProjectsHelper
  def estimated(story)
    @estimate_id = story.estimate_for(current_user)
    @estimate_id.present?
  end

  def is_unlocked?(model)
    policy(model).update?
  end

  def link_unless_archived(project, text, url, classes: nil, method: :get, remote: false, icon: nil, data_attr: nil, id: nil)
    link_text = text_content(icon, text)
    if project.archived? || project.parent&.archived?
      button_tag(link_text, disabled: true, class: "button #{classes} disabled", aria: {disabled: true})
    else
      link_to(link_text, url, class: "button #{classes}", title: text, method: method, remote: remote, data: data_attr, id: id)
    end
  end

  private

  def text_content(icon, text)
    return text if icon.nil?

    content_tag(:i, "", class: "fa fa-#{icon}").concat(content_tag(:span, text))
  end
end
