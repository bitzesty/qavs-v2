class FormAnswerStatus::AdminFilter
  extend FormAnswerStatus::FilteringHelper
  include NomineeActivityHelper

  SUB_OPTIONS = {
    assessors_not_assigned: {
      label: "Assessors not assigned"
    },
    missing_rsvp_details: {
      label: "Missing RSVP Details"
    }
  }

  OPTIONS = {
    eligibility_in_progress: {
      label: "Eligibility in progress",
      states: [:eligibility_in_progress]
    },
    application_in_progress: {
      label: "Nomination in progress",
      states: [:application_in_progress]
    },
    applications_not_submitted: {
      label: "Nomination not submitted",
      states: [:not_submitted]
    },
    submitted: {
      label: "Nomination submitted",
      states: [:submitted]
    },
    admin_eligible: {
      label: "Eligible by admin",
      states: [:admin_eligible]
    },
    admin_eligible_duplicate: {
      label: "Eligible - duplicate to access",
      states: [:admin_eligible_duplicate]
    },
    admin_not_eligible_duplicate: {
      label: "Duplicate for reference",
      states: [:admin_not_eligible_duplicate]
    },
    admin_not_eligible_nominator: {
      label: "Ineligible - nominator",
      states: [:admin_not_eligible_nominator]
    },
    admin_not_eligible_group: {
      label: "Ineligible - group",
      states: [:admin_not_eligible_group]
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
    withdrawn: {
      label: "Withdrawn",
      states: [
        :withdrawn
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

  def self.sub_options
    SUB_OPTIONS
  end
end
