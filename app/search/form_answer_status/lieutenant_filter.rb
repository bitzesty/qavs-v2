class FormAnswerStatus::LieutenantFilter
  extend FormAnswerStatus::FilteringHelper
  include NomineeActivityHelper

  OPTIONS = {
    submitted: {
      label: "Nomination submitted",
      states: [:submitted]
    },
    admin_eligible: {
      label: "Eligible by admin",
      states: [:admin_eligible]
    },
    admin_eligible_duplicate: {
      label: "Eligible by admin - duplicate to assess",
      states: [:admin_eligible_duplicate]
    },
    local_assessment_in_progress: {
      label: "Local assessment in progress",
      states: [:local_assessment_in_progress]
    },
    local_assessment_recommended: {
      label: "Local assessment - recommended",
      states: [:local_assessment_recommended]
    },
    local_assessment_not_recommended: {
      label: "Local assessment - not recommended",
      states: [:local_assessment_not_recommended]
    },
    recommended: {
      label: "Shortlisted",
      states: [
        :shortlisted
      ]
    },
    not_recommended: {
      label: "Not recomended",
      states: [
        :not_recommended
      ]
    },
    not_eligible: {
      label: "Ineligible - questionnaire",
      states: [
        :not_eligible
      ]
    },
    undecided: {
      label: "Undecided",
      states: [
        :undecided
      ]
    },
    no_royal_approval: {
      label: "No Royal approval",
      states: [
        :no_royal_approval
      ]
    },
    not_eligible: {
      label: "Ineligible - questionnaire",
      states: [
        :not_eligible
      ]
    },
    awarded: {
      label: "Royal approval - awarded",
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
