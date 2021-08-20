class FormAnswerStateMachine
  include Statesman::Machine

  STATES = [
    :eligibility_in_progress,
    :application_in_progress,
    :submitted,
    :withdrawn,
    :not_eligible,
    :not_submitted,
    # eligibility
    :admin_eligible,
    :admin_eligible_duplicate,
    :admin_not_eligible_duplicate,
    :admin_not_eligible_nominator,
    :admin_not_eligible_group,
    # / eligibility
    :local_assessment_in_progress,
    :local_assessment_recommended,
    :local_assessment_not_recommended,
    :assessment_in_progress,
    :disqualified,
    :recommended,
    :reserved,
    :not_recommended,
    :awarded,
    :not_awarded
  ]

  POSITIVE_STATES = [
    :reserved,
    :recommended,
    :awarded
  ]

  POST_SUBMISSION_STATES = [
    :submitted,
    :withdrawn,
    :admin_eligible,
    :admin_eligible_duplicate,
    :admin_not_eligible_duplicate,
    :admin_not_eligible_nominator,
    :admin_not_eligible_group,
    :local_assessment_in_progress,
    :local_assessment_recommended,
    :local_assessment_not_recommended,
    :assessment_in_progress,
    :disqualified,
    :recommended,
    :reserved,
    :not_recommended,
    :awarded,
    :not_awarded
  ]

  ELIGIBILITY_STATES = [
    :admin_eligible,
    :admin_eligible_duplicate,
    :admin_not_eligible_duplicate,
    :admin_not_eligible_nominator,
    :admin_not_eligible_group,
    :withdrawn
  ]

  NOT_ELIGIBLE_STATES = [
    :admin_not_eligible_duplicate,
    :admin_not_eligible_nominator,
    :admin_not_eligible_group,
    :withdrawn
  ]

  NOT_POSITIVE_STATES = [
    :not_recommended,
    :not_awarded
  ]

  POST_ELIGIBLE_STATES = [
    :admin_eligible,
    :admin_eligible_duplicate,
    :local_assessment_in_progress,
    :local_assessment_recommended,
    :local_assessment_not_recommended,
    :assessment_in_progress,
    :disqualified,
    :recommended,
    :reserved,
    :not_recommended,
    :awarded,
    :not_awarded
  ]

  state :eligibility_in_progress, initial: true
  state :application_in_progress
  state :submitted
  state :withdrawn
  state :not_eligible
  state :not_submitted
  state :admin_eligible
  state :admin_eligible
  state :admin_eligible_duplicate
  state :admin_not_eligible_duplicate
  state :admin_not_eligible_nominator
  state :admin_not_eligible_group
  state :local_assessment_in_progress
  state :local_assessment_recommended
  state :local_assessment_not_recommended
  state :assessment_in_progress
  state :disqualified
  state :recommended
  state :reserved
  state :not_recommended
  state :awarded
  state :not_awarded

  STATES.each do |state1|
    STATES.each do |state2|
      transition from: state1, to: state2
    end
  end

  def self.trigger_deadlines
    if Settings.after_current_submission_deadline?
      current_year = Settings.current.award_year

      current_year.form_answers.where(state: "submitted").find_each do |fa|
        fa.state_machine.perform_transition("assessment_in_progress")
      end

      current_year.form_answers.in_progress.find_each do |fa|
        fa.state_machine.perform_transition("not_submitted")
      end
    end
  end

  def collection(subject)
    permitted_states_with_deadline_constraint
  end

  def perform_transition(state, subject = nil, validate = true)
    state = state.to_sym if STATES.map(&:to_s).include?(state)
    meta = get_metadata(subject)

    if permitted_states_with_deadline_constraint.include?(state) || !validate
      if transition_to state, meta
        if state == :submitted
          object.update(submitted_at: Time.current)
        end

        if state == :withdrawn
          Notifiers::WithdrawNotifier.new(object).notify
        end
      end
    end
  end

  def perform_simple_transition(state)
    perform_transition(state, nil, false) unless object.state == state
  end

  def submit(subject)
    # TODO: tech debt - we store the submitted state in 2 places
    # in state machine and in `form_answers.submitted`
    meta = get_metadata(subject)
    transition_to :submitted, meta
    object.update(submitted_at: Time.current)
  end


  def assign_lead_verdict(verdict, subject)
    new_state = {
      "negative" => :not_recommended,
      "average" => :reserved,
      "positive" => :recommended
    }[verdict]

    perform_transition(new_state, subject)
  end

  def after_eligibility_step_progress
    if object.eligible? # already eligible
      perform_simple_transition :application_in_progress
    else
      perform_simple_transition :eligibility_in_progress
    end
  end

  def after_eligibility_step_failure
    perform_simple_transition :not_eligible
  end

  # store the state directly in model attribute
  after_transition do |model, transition|
    model.state = transition.to_state
    model.save
  end

  private

  def get_metadata(subject)
    meta = {
      transitable_id: subject.id,
      transitable_type: subject.class.to_s
    } if subject.present?
    meta ||= {}
    meta
  end

  def permitted_states_with_deadline_constraint
    if Settings.after_current_submission_deadline?
      all_states = [
        :admin_eligible,
        :admin_eligible_duplicate,
        :admin_not_eligible_duplicate,
        :admin_not_eligible_nominator,
        :admin_not_eligible_group,
        :local_assessment_in_progress,
        :local_assessment_recommended,
        :local_assessment_not_recommended,
        :assessment_in_progress,
        :recommended,
        :reserved,
        :not_recommended,
        :disqualified,
        :awarded,
        :not_awarded,
        :withdrawn
      ]

      case object.state.to_sym
      when :not_eligible
        []
      when *(ELIGIBILITY_STATES - [:admin_eligible, :admin_eligible_duplicate])
        ELIGIBILITY_STATES
      when :application_in_progress, :eligibility_in_progress
        [:not_submitted]
      when :submitted
        ELIGIBILITY_STATES
      when :not_submitted
        []
      when :admin_eligible, :admin_eligible_duplicate
        [:local_assessment_in_progress] + ELIGIBILITY_STATES
      when :local_assessment_in_progress
        [:local_assessment_recommended, :local_assessment_not_recommended] + NOT_ELIGIBLE_STATES
      when :local_assessment_recommended
        [:local_assessment_not_recommended, :assessment_in_progress] + NOT_ELIGIBLE_STATES
      when :local_assessment_not_recommended
        [:local_assessment_recommended] + NOT_ELIGIBLE_STATES
      else
        all_states
      end
    else
      []
    end
  end
end
