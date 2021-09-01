class FormAnswerStatus::LieutenantFilter
  extend FormAnswerStatus::FilteringHelper
  include NomineeActivityHelper

  OPTIONS = {
    submitted: {
      label: "Application submitted",
      states: [:submitted]
    },
    admin_eligible: {
      label: "Admin: Eligible",
      states: [:admin_eligible]
    },
    admin_eligible_duplicate: {
      label: "Eligible - duplicate to access",
      states: [:admin_eligible_duplicate]
    },
    local_assessment_in_progress: {
      label: "Local assessment in progress",
      states: [:local_assessment_in_progress]
    },
    local_assessment_recommended: {
      label: "Local assessment: recommended",
      states: [:local_assessment_recommended]
    },
    local_assessment_not_recommended: {
      label: "Local assessment: not recommended",
      states: [:local_assessment_not_recommended]
    },
    assessment_in_progress: {
      label: "Assessment in progress",
      states: [:assessment_in_progress]
    },
    disqualified: {
      label: "Disqualified - No Verification of Commercial Figures",
      states: [:disqualified]
    },
    recommended: {
      label: "Recommended",
      states: [
        :recommended
      ]
    },
    reserve: {
      label: "Reserved",
      states: [
        :reserved
      ]
    },
    not_recommended: {
      label: "Not recomended",
      states: [
        :not_recommended
      ]
    },
    not_eligible: {
      label: "Not eligible",
      states: [
        :not_eligible
      ]
    },
    awarded: {
      label: "Awarded",
      states: [
        :awarded
      ]
    },
    not_awarded: {
      label: "Not Awarded",
      states: [
        :not_awarded
      ]
    }
  }

  def self.options
    OPTIONS
  end

  def self.checked_options
    activity_options
  end
end
