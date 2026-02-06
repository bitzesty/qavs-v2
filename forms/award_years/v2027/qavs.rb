require_relative "qavs/qavs_step1"
require_relative "qavs/qavs_step2"
require_relative "qavs/qavs_step3"
require_relative "qavs/qavs_step4"
require_relative "qavs/qavs_step5"

class AwardYears::V2027::QaeForms
  class << self
    def qavs
      @qavs ||= QaeFormBuilder.build "King's Award for Voluntary Service Nomination" do
        step "nominee",
             &AwardYears::V2027::QaeForms.qavs_step1

        step "recommendation",
             &AwardYears::V2027::QaeForms.qavs_step2

        step "letters_of_support",
             { id: :letters_of_support_step },
             &AwardYears::V2027::QaeForms.qavs_step3

        step "submit_step",
             &AwardYears::V2027::QaeForms.qavs_step4

        step "local_assessment_form",
             { id: :local_assessment },
             &AwardYears::V2027::QaeForms.qavs_step5
      end
    end
  end
end
