class SeparatedDateTimeInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options)
    out = ''.html_safe

    out << '<div class="govuk-form-group">'.html_safe
    out << "<label for='formatted_#{attribute_name}_date' class='govuk-label'>#{wrapper_options[:date_label]}</label>".html_safe
    out << @builder.text_field("formatted_#{attribute_name}_date",
                               input_html_options.merge(class: "govuk-input medium datepicker",
                                                        placeholder: "dd/mm/yyyy",
                                                        'aria-label' => 'Date',
                                                        id: "formatted_#{attribute_name}_date")).html_safe
    out << '</div>'.html_safe
    out << '<div class="govuk-form-group">'.html_safe
    out << "<label for='formatted_#{attribute_name}_time' class='govuk-label'>#{wrapper_options[:time_label]}</label>".html_safe
    out << @builder.text_field("formatted_#{attribute_name}_time",
                               input_html_options.merge(class: "govuk-input medium timepicker",
                                                        placeholder: "hh:mm",
                                                        'aria-label' => 'Time',
                                                        id: "formatted_#{attribute_name}_time")).html_safe
    out << '</div>'.html_safe
    out
  end

  def label(wrapper_options)
    ""
  end
end
