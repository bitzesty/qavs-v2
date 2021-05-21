require "award_years/v2022/qavs/qavs_step1"
require "award_years/v2022/qavs/qavs_step2"
require "award_years/v2022/qavs/qavs_step3"
require "award_years/v2022/qavs/qavs_step4"
require "award_years/v2022/qavs/qavs_step5"
require "award_years/v2022/qavs/qavs_step6"

class AwardYears::V2022::QAEForms
  class << self
    def qavs
      @qavs ||= QAEFormBuilder.build "Promoting Opportunity Award (through social mobility) Application" do
        step "Company Information",
             "Company Information",
             &AwardYears::V2022::QAEForms.qavs_step1

        step "Your Social Qavs Programme(s)",
             "Your Social Qavs",
             &AwardYears::V2022::QAEForms.qavs_step2

        step "Commercial Performance",
             "Commercial Performance",
             &AwardYears::V2022::QAEForms.qavs_step3

        step "Declaration of Corporate Responsibility",
             "Declaration of Corporate Responsibility",
             &AwardYears::V2022::QAEForms.qavs_step4

        step "Add Website Address/Documents",
             "Add Website Address/Documents",
             { id: :add_website_address_documents_step },
             &AwardYears::V2022::QAEForms.qavs_step5

        step "Authorise & Submit",
             "Authorise & Submit",
             &AwardYears::V2022::QAEForms.qavs_step6
      end
    end
  end
end
