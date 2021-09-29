module FormHelper
  def possible_read_only_ops(section = :default)
    ops = {}

    if admin? && !admin_in_read_only_mode?
      if section != :local_assessment
        return ops
      else
        ops[:disabled] = "disabled"
      end
    elsif lieutenant_nomination? && section != :local_assessment
      ops[:disabled] = "disabled"
    elsif current_form_is_not_editable? && section != :local_assessment
      ops[:disabled] = "disabled"
    elsif current_assessor
      ops[:disabled] = "disabled"
    end

    ops
  end

  def current_form_is_editable?
    !current_form_is_not_editable?
  end

  def current_form_is_not_editable?
    admin_in_read_only_mode? || current_form_submission_ended?
  end

  def lieutenant_nomination?
    current_subject.is_a?(Lieutenant)
  end

  def admin?
    current_subject.is_a?(Admin)
  end

  def nomination_pdf_url(nomination)
    if current_user
      users_form_answer_path(nomination, format: :pdf)
    elsif current_lieutenant
      lieutenant_form_answer_path(nomination, format: :pdf)
    elsif current_admin
      admin_form_answer_path(nomination, format: :pdf)
    elsif current_assessor
      assessor_form_answer_path(nomination, format: :pdf)
    end
  end

  def letter_of_support_pdf_url(letter)
    if current_lieutenant
      namespace_name = :lieutenant
    elsif current_admin
      namespace_name = :admin
    elsif current_assessor
      namespace_name = :assessor
    end
    [namespace_name, letter.form_answer, letter]
  end

  def nomination_back_url(nomination, step)
    if current_user
      edit_form_url(step: step.previous.title_to_param)
    elsif current_lieutenant
      edit_lieutenant_form_answer_url(nomination, step: step.previous.title_to_param)
    elsif current_admin
      edit_admin_form_answer_url(nomination, step: step.previous.title_to_param)
    elsif current_assessor
      edit_assessor_form_answer_url(nomination, step: step.previous.title_to_param)
    end
  end

  def nomination_dashboard_link(nomination)
    if current_subject.is_a?(Lieutenant)
      lieutenant_form_answer_url(nomination)
    elsif admin?
      admin_form_answer_url(nomination)
    elsif current_assessor
      assessor_form_answer_url(nomination)
    else
      dashboard_url
    end
  end

  def next_step(form, step)
    return unless step

    steps = form.steps
    steps.map! { |s| s.title_to_param }

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
