class FormAnswerPolicy < ApplicationPolicy
  def index?
    admin? || assessor? || lieutenant?
  end

  # if subject is a lead or admin
  # or the assessment is submitted, and it's a primary assessor
  # or the assessment is submitted, and it's an application from previous award years and the subject is an assessor
  def show_section_appraisal_moderated?
    subject.lead?(record) ||
      (
        record.assessor_assignments.moderated.submitted? &&
        (
          subject.primary?(record) ||
          (assessor? && record.from_previous_years?)
        )
      )
  end

  def review?
    record.award_year.current? &&
    (

      !lieutenant? &&
      (admin? ||
       subject.lead_or_assigned?(record))
    )
  end

  def show?
    admin? || assessor? || (lieutenant? && lieutenancy_assigned?)
  end

  def lieutenant_assessment?
    (lieutenant? && lieutenancy_assigned?) || admin?
  end

  def edit?
    deadline = record.award_year.settings.winners_email_notification.try(:trigger_at)
    ((lieutenant? && lieutenancy_assigned?) || admin?) && (!deadline.present? || DateTime.now <= deadline)
  end

  def submit?
    nominator? || lieutenant? && lieutenancy_assigned? && advanced_lieutenant? || admin?
  end

  def update?
    admin? || subject.lead?(record)
  end

  def eligibility?
    admin?
  end

  def update_eligibility?
    admin?
  end

  def update_item?(item)
    admin_or_lead_or_primary = admin? || (subject.lead?(record) ||
                               subject.primary?(record))

    if item.in? [:previous_wins, :sic_code]
      admin_or_lead_or_primary
    else
      admin_or_lead_or_primary &&
          record.submitted_and_after_the_deadline? &&
          update?
    end
  end

  def update_company?
    CompanyDetailPolicy.new(subject, record).can_manage_company_name?
  end

  def can_update_by_admin_lead_and_primary_assessors?
    !lieutenant? && (admin? || subject.lead?(record) || subject.primary?(record))
  end

  def update_financials?
    !lieutenant && (admin? || subject.lead?(record) || subject.primary?(record))
  end

  def assign_assessor?
    !lieutenant? && (admin? || subject.lead?(record))
  end

  def assign_lieutenancy?
    admin?
  end

  def toggle_admin_flag?
    admin?
  end

  def toggle_assessor_flag?
    admin? || (!lieutenant? && subject.lead_or_assigned?(record))
  end

  def download_feedback_pdf?
    admin? && record.submitted? && record.feedback.present?
  end

  def download_case_summary_pdf?
    admin? && record.in_positive_state? && record.lead_or_primary_assessor_assignments.any?
  end

  def download_list_of_procedures_pdf?
    !lieutenant? &&
    (admin? || subject.lead_or_assigned?(record)) &&
    record.list_of_procedures.present? &&
    record.list_of_procedures.attachment.present? &&
    (Rails.env.development? || record.list_of_procedures.clean?)
  end

  def has_access_to_post_shortlisting_docs?
    download_feedback_pdf? ||
    download_case_summary_pdf? ||
    (admin? || subject.lead_or_assigned?(record))
  end

  def can_download_initial_audit_certificate_pdf?
    admin? && record.shortlisted?
  end

  def can_see_corp_responsibility?
    record.shortlisted?
  end

  def can_review_corp_responsibility?
    can_see_corp_responsibility? &&
    can_update_by_admin_lead_and_primary_assessors?
  end

  def can_download_original_pdf_of_application_before_deadline?
    (can_update_by_admin_lead_and_primary_assessors? || assessor?) &&
      record.submitted? &&
      record.submission_ended? &&
      record.pdf_version.present?
  end

  def can_add_collaborators_to_application?
    admin?
  end

  def lieutenancy_assigned?
    record.ceremonial_county == subject.ceremonial_county
  end

  def can_see_national_assessment_status?
    admin? || assessor?
  end
end
