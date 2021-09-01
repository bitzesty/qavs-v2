class FormAnswerValidator
  attr_reader :award_form, :form_answer, :current_step, :errors

  def initialize(form_answer)
    @form_answer = form_answer

    answers = HashWithIndifferentAccess.new(form_answer.document)
    @award_form = form_answer.award_form.decorate(answers: answers)
    @current_step = form_answer.current_step

    @errors = {}
  end

  def valid?
    form_answer.steps_with_errors = []
    award_form.steps.each do |step|

      # skip lieutenants step validation
      next if step.opts[:id] == :local_assessment

      # if form was submitted before
      # we should validate current step
      # else if form was submitted just now
      # we should validate entire form

      if step.title_to_param == current_step || (form_answer.submitted_at_changed? && form_answer.submitted_at_was.nil?)
        step.questions.each do |q|
          if (errors = q.validate).any?
            @errors.merge!(errors)
            form_answer.steps_with_errors << step.title_to_param
          end
        end
      end
    end

    @errors.none?
  end
end
