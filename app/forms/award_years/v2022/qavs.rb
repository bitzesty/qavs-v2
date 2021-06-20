require "award_years/v2022/qavs/qavs_step1"
require "award_years/v2022/qavs/qavs_step2"
require "award_years/v2022/qavs/qavs_step3"
require "award_years/v2022/qavs/qavs_step4"

class AwardYears::V2022::QAEForms
  class << self
    def qavs
      @qavs ||= QAEFormBuilder.build "Queen's Award for Voluntary Service Nomination" do
        step "Nominee",
             "Nominee",
             &AwardYears::V2022::QAEForms.qavs_step1

        step "Your Recommendation",
             "Your Recommendation",
             &AwardYears::V2022::QAEForms.qavs_step2

        step "Letters of Support",
             "Letters of Support",
             { id: :letters_of_support_step },
             &AwardYears::V2022::QAEForms.qavs_step3

        step "Authorise & Submit",
             "Authorise & Submit",
             &AwardYears::V2022::QAEForms.qavs_step4
      end
    end
  end
end
