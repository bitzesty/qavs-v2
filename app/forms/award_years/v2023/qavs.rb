require "award_years/v2023/qavs/qavs_step1"
require "award_years/v2023/qavs/qavs_step2"
require "award_years/v2023/qavs/qavs_step3"
require "award_years/v2023/qavs/qavs_step4"
require "award_years/v2023/qavs/qavs_step5"

class AwardYears::V2023::QAEForms
  class << self
    def qavs
      @qavs ||= QAEFormBuilder.build "Queen's Award for Voluntary Service Nomination" do
        step "nominee",
             &AwardYears::V2023::QAEForms.qavs_step1

        step "recommendation",
             &AwardYears::V2023::QAEForms.qavs_step2

        step "letters_of_support",
             { id: :letters_of_support_step },
             &AwardYears::V2023::QAEForms.qavs_step3

        step "submit_step",
             &AwardYears::V2023::QAEForms.qavs_step4

        step "local_assessment_form",
             { id: :local_assessment },
             &AwardYears::V2023::QAEForms.qavs_step5
      end
    end
  end
end
