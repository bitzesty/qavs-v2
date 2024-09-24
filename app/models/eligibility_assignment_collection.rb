class EligibilityAssignmentCollection < AssignmentCollection
  VALID_STATES = %w[submitted admin_pending_eligibility].freeze


  attribute :state, String

  validates :state, presence: true, inclusion: { in: FormAnswerStateMachine::ELIGIBILITY_STATES.map(&:to_s) }

  validate :form_answers_state_validation

  def save
    return unless valid?
    form_answers.update_all(state: state)
  end

  def notice_message
    if ids.length > 1
      "Groups have"
    else
      "Group has"
    end.concat " been assigned the #{state} status."
  end

  private

  def form_answers_state_validation
    unless form_answers.all? { |form_answer| VALID_STATES.include?(form_answer.state) }
      errors.add(:form_answer_ids, "To assign the eligibility status, you must only select groups that currently have ‘Nomination submitted’ or ‘Eligibility pending’ status.")
    end
  end
end
