class LocalAssessmentSubmissionService
  attr_reader :form_answer, :lieutenant

  def initialize(form_answer, lieutenant)
    @form_answer = form_answer
    @lieutenant = lieutenant
  end

  def submit!
    puts form_answer.document["local_assessment_verdict"]
    case form_answer.document["local_assessment_verdict"]
    when "recommended"
      form_answer.state_machine.perform_transition(:local_assessment_recommended, lieutenant)
    when "not_recommended"
      form_answer.state_machine.perform_transition(:local_assessment_not_recommended, lieutenant)
    else
      raise ArgumentError, "FormAnswer##{form_answer.id} is not valid for state transition"
    end
  end
end
