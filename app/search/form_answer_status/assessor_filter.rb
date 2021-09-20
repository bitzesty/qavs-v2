class FormAnswerStatus::AssessorFilter
  extend FormAnswerStatus::FilteringHelper

  OPTIONS = {
    local_assessment_recommended: {
      label: "Local assessment - recommended",
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
      label: "National assessment shortlisted",
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
      states: [:withdrawn]
    },
    submitted: {
      label: "Submitted",
      states: [:submitted]
    },
    awarded: {
      label: "Royal approval - awarded",
      states: [:awarded]
    },
    not_awarded: {
      label: "Not Awarded",
      states: [:not_awarded]
    }
  }


  SUB_OPTIONS = {
    assessors_not_assigned: {
      label: "National assessors not assigned"
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
