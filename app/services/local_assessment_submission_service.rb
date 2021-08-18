class LocalAssessmentSubmissionService
  attr_reader :form_answer, :user

  def initialize(form_answer, user)
    @form_answer = form_answer
    @user = user
  end

  def submit!
    case form_answer.document["local_assessment_verdict"]
    when "recommended"
      form_answer.state_machine.perform_transition(:local_assessment_recommended, user)
    when "not_recommended"
      form_answer.state_machine.perform_transition(:local_assessment_not_recommended, user)
    else
      raise ArgumentError, "FormAnswer##{form_answer.id} is not valid for state transition"
    end
  end
end
