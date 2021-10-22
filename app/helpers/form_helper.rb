module FormHelper
  def custom_text_field(form, field, errors = [], options = {})
    input_wrapper(form, field, errors, options) do
      form.text_field(field, class: options[:field_class], placeholder: options[:placeholder])
    end
  end

  def custom_textarea_field(form, field, errors = [], options = {})
    input_wrapper(form, field, errors, options) do
      form.text_area(field, id: field, class: options[:field_class], placeholder: options[:placeholder],
                            rows: options[:rows])
    end
  end

  protected

  def input_wrapper(form, field, errors, options)
    content_tag(:div, class: options[:div_class]) do
      form.label(field, "#{"* " if options[:required]}#{options[:label] || field.to_s.humanize}") +
        yield +
        content_tag(:div, class: "form-text text-muted #{"text-danger" if errors.present?}") do
          errors.present? ? "(#{errors.to_sentence})" : options[:hint]
        end
    end
  end
end
