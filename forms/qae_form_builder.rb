require_relative "qae_form_builder/qae_decorator"
require_relative "qae_form_builder/qae_form"
require_relative "qae_form_builder/step"
require_relative "qae_form_builder/question"
require_relative "qae_form_builder/multi_question_decorator"
require_relative "qae_form_builder/multi_question_validator"

require_relative "qae_form_builder/header_question"
require_relative "qae_form_builder/comment_question"
require_relative "qae_form_builder/text_question"
require_relative "qae_form_builder/number_question"
require_relative "qae_form_builder/textarea_question"
require_relative "qae_form_builder/options_question"
require_relative "qae_form_builder/dropdown_question"
require_relative "qae_form_builder/regions_question"
require_relative "qae_form_builder/sic_code_dropdown_question"
require_relative "qae_form_builder/date_question"
require_relative "qae_form_builder/year_question"
require_relative "qae_form_builder/upload_question"
require_relative "qae_form_builder/options_business_name_changed_question"

require_relative "qae_form_builder/previous_name_question"
require_relative "qae_form_builder/country_question"
require_relative "qae_form_builder/address_question"
require_relative "qae_form_builder/head_of_business_question"
require_relative "qae_form_builder/user_info_question"

require_relative "qae_form_builder/by_years_label_question"
require_relative "qae_form_builder/by_years_question"
require_relative "qae_form_builder/one_option_by_years_label_question"
require_relative "qae_form_builder/one_option_by_years_question"
require_relative "qae_form_builder/confirm_question"
require_relative "qae_form_builder/checkbox_seria_question"
require_relative "qae_form_builder/contact_email_question"
require_relative "qae_form_builder/contact_question"
require_relative "qae_form_builder/supporters_question"
require_relative "qae_form_builder/assessor_details_question"


class QaeFormBuilder
  class << self

    def build title, &block
      form = QaeForm.new title
      form.instance_eval &block if block_given?
      form
    end

  end
end
