module FormHelper
  def possible_read_only_ops
    ops = {}

    if current_form_is_not_editable?
      ops[:disabled] = "disabled"
      ops[:class] = "read-only"
    end

    ops
  end

  def current_form_is_editable?
    !current_form_is_not_editable?
  end

  def current_form_is_not_editable?
    admin_in_read_only_mode? ||
      (current_form_submission_ended? &&
       !lieutenant_nomination?)
  end

  def lieutenant_nomination?
    current_subject.is_a?(Lieutenant)
  end

  def next_step(form, step)
    return unless step

    steps = form.steps
    steps.map! { |s| s.title.parameterize }

    index = steps.index(step)

    steps[index + 1]
  end

  def text_words_count(text)
    text.to_s.split.count
  end

  def hide_step?(step, nomination, subject)
    step.opts[:id] == :local_assessment && !policy(@form_answer).lieutenant_assessment? # && let's add a date condition
  end
end
