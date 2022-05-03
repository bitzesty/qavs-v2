module Reports::DataPickers::FormDocumentPicker

  def business_region
    doc "organization_address_region"
  end

  def business_reg_no
    doc "registration_number"
  end

  def unit_website
    doc "website_url"
  end

  def head_surname
    doc("head_of_business_last_name")
  end

  def head_first_name
    doc("head_of_business_first_name")
  end

  def head_position
    doc("head_job_title")
  end

  def head_full_name
    "#{doc('head_of_business_title')} #{doc('head_of_business_first_name')} #{doc('head_of_business_last_name')} #{doc('head_of_business_honours')}"
  end

  def personal_honours
    doc "head_of_business_honours"
  end

  def nominee_first_name
    doc "nominee_info_first_name"
  end

  def nominee_surname
    doc "nominee_info_last_name"
  end

  def nominee_email
    doc "nominee_email"
  end

  def head_email
    doc "head_email"
  end

  def head_title
    doc("head_of_business_title")
  end

  def principal_postcode
    doc("organization_address_postcode").to_s.upcase
  end

  def principal_address1
    doc "organization_address_building"
  end

  def principal_address2
    doc "organization_address_street"
  end

  def principal_address3
    doc "organization_address_city"
  end

  def principal_county
    doc "organization_address_county"
  end

  def immediate_parent_country
    country_name(doc_including_hidden("parent_company_country"))
  end

  def organisation_with_ultimate_control_country
    country_name(doc("ultimate_control_company_country"))
  end

  def organisation_with_ultimate_control
    doc("ultimate_control_company")
  end


  def product_service
    service = doc("application_category") == "initiative" ? doc("initiative_desc_short") : doc("organisation_desc_short")

    ActionView::Base.full_sanitizer.sanitize(service)
  end

  def date_started_trading
    day = doc("started_trading_day")
    month = doc("started_trading_month")
    year = doc("started_trading_year")

    if year && month && day
      Date.new(year.to_i, month.to_i, day.to_i).strftime("%m/%d/%Y") rescue nil
    end
  end

  def immediate_parent_name
    doc_including_hidden("parent_company")
  end

  def doc(key)
    obj.document[key] if key.present? && question_visible?(key)
  end

  # shows hidden questions
  def doc_including_hidden(key)
    obj.document[key]
  end

  def country_name(code)
    if code.present?
      country = ISO3166::Country[code]
      country.name
    end
  end
end
