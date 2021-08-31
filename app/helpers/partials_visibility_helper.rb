module PartialsVisibilityHelper
  def show_winners_section?
    @form_answer.awarded? || @form_answer.shortlisted?
  end

  def show_press_summary_subsection?
    (@form_answer.awarded? || @form_answer.shortlisted?) &&
      admin_or_assined_assessor?
  end

  def show_palace_attendees_subsection?
    @form_answer.awarded? && admin_or_assined_assessor?
  end

  def show_form_answer_attachment?(attachment)
    current_subject.is_a?(Admin) || !attachment.restricted_to_admin?
  end

  def show_remove_form_answer_attachment?(attachment)
    attachment.uploaded_not_by_user? && policy(attachment).destroy?
  end

  private

  def admin_or_assined_assessor?
    current_subject.is_a?(Admin) ||
    current_subject.assigned?(@form_answer)
  end
end
