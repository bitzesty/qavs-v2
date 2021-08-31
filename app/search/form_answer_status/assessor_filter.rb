class FormAnswerStatus::AssessorFilter
  extend FormAnswerStatus::FilteringHelper

  OPTIONS = {
    local_assessment_recommended: {
      label: "Local assessment: recommended",
      states: [:local_assessment_recommended]
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
      states: [:recommended]
    },
    not_recommended: {
      label: "Not Recommended",
      states: [:not_recommended]
    },
    reserved: {
      label: "Reserved",
      states: [:reserved]
    },
    withdrawn: {
      label: "Withdrawn/Ineligible",
      states: [:withdrawn]
    },
    submitted: {
      label: "Submitted",
      states: [:submitted]
    },
    awarded: {
      label: "Awarded",
      states: [:awarded]
    },
    not_awarded: {
      label: "Not Awarded",
      states: [:not_awarded]
    }
  }

  SUB_OPTIONS = {
    missing_sic_code: {
      label: "Missing SIC code"
    },
    assessors_not_assigned: {
      label: "Assessors not assigned"
    },
    primary_assessment_submitted: {
      label: "Primary Assessment submitted"
    },
    secondary_assessment_submitted: {
      label: "Secondary Assessment submitted"
    },
    primary_and_secondary_assessments_submitted: {
      label: "Primary and Secondary Assessments submitted"
    },
    primary_assessment_not_submitted: {
      label: "Primary Assessment not submitted"
    },
    secondary_assessment_not_submitted: {
      label: "Secondary Assessment not submitted"
    },
    recommendation_disperancy: {
      label: "Recommendation discrepancy"
    },
    missing_audit_certificate: {
      label: "Missing Verification of Commercial Figures"
    },
    audit_certificate_not_reviewed: {
      label: "Verification of Commercial Figures - not reviewed yet"
    },
    missing_feedback: {
      label: "Missing Feedback"
    },
    missing_press_summary: {
      label: "Missing Press Summary"
    }
  }

  def self.checked_options
    OPTIONS.except(:eligibility_in_progress, :application_in_progress)
  end

  def self.options
    OPTIONS
  end

  def self.sub_options
    SUB_OPTIONS
  end

end
