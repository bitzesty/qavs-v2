class FormAnswerStatus::AdminFilter
  extend FormAnswerStatus::FilteringHelper
  include NomineeActivityHelper

  SUB_OPTIONS = {
    lord_lieutenancy_not_assigned: {
      label: "Lord Lieutenancy not assigned"
    },
    local_assessment_not_started: {
      label: "Local assessment not started"
    },
    assessors_not_assigned: {
      label: "National assessors not assigned"
    },
    national_assessment_outcome_pending: {
      label: "National assessment outcome pending"
    },
    citation_not_submitted: {
      label: "Citation form not submitted"
    },
    missing_rsvp_details: {
      label: "Royal Garden Party form not submitted"
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
    admin_pending_eligibility: {
      label: "Admin: Pending Eligibility",
      states: [:admin_pending_eligibility]
    },
    admin_eligible_duplicate: {
      label: "Eligible by admin - duplicate to assess",
      states: [:admin_eligible_duplicate]
    },
    admin_not_eligible_duplicate: {
      label: "Duplicate for reference",
      states: [:admin_not_eligible_duplicate]
    },
    admin_not_eligible_nominator: {
      label: "Ineligible by admin - nominator",
      states: [:admin_not_eligible_nominator]
    },
    admin_not_eligible_group: {
      label: "Ineligible by admin - group",
      states: [:admin_not_eligible_group]
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
      label: "National assessment - shortlisted",
      states: [
        :shortlisted
      ]
    },
    not_recommended: {
      label: "National assessment - not recommended",
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
      label: "National assessment - undecided",
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

  def self.sub_options
    SUB_OPTIONS
  end
end
