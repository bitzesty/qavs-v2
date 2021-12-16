class UserDecorator < ApplicationDecorator
  include UserSharedDecorator

  def general_info
    "#{object.company_name}: #{full_name}"
  end

  def general_info_print
    if object.company_name.present?
      "<b>#{object.company_name.upcase}:</b> #{full_name.upcase}"
    else
      full_name.upcase
    end
  end

  def applicant_info_print
    object.company_name || full_name
  end

  def confirmation_status
    " (Pending)" unless object.confirmed?
  end

  def full_name_with_status
    "#{full_name}#{confirmation_status}"
  end

  def company
    company_name.presence || '<span class="text-muted">N/A</span>'.html_safe
  end

  def date_format(val)
    val.strftime("%d %b %Y")
  end
end
