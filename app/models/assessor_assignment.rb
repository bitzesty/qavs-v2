class AssessorAssignment < ApplicationRecord

  has_paper_trail unless: Proc.new { |t| Rails.env.test? }

  begin :validations
    validates :form_answer_id,
              presence: true

    validate :mandatory_fields_for_submitted

    validate do
      validate_rate :evidence
      validate_rate :verdict
    end

    validates :assessor_id,
              uniqueness: { scope: [:form_answer_id] },
              allow_nil: true
  end

  begin :associations
    belongs_to :assessor, optional: true
    belongs_to :form_answer, optional: true
    belongs_to :editable, polymorphic: true, optional: true
    belongs_to :award_year, optional: true
  end

  begin :scopes
    scope :submitted, -> { where.not(submitted_at: nil) }
  end

  before_create :set_award_year!

  store_accessor :document, *AppraisalForm.all

  attr_accessor :submission_action

  def submitted?
    submitted_at.present?
  end

  def locked?
    locked_at.present?
  end

  def visible_for?(subject)
    return true if owner_or_administrative?(subject)
    # Adds ability to view assessments of past applications
    if subject.is_a?(Assessor) && form_answer.from_previous_years?
      return true
    end

    if assessments.all?(&:submitted?)
      return assessments.any? { |a| a.assessor_id == subject.id }
    end

    false
  end

  def editable_for?(subject)
    role_allow_to_edit?(subject)
  end

  def role_allow_to_edit?(subject)
    admin?(subject) ||
      (subject.assigned?(form_answer) && assessor_can_edit?(subject))
  end

  def assessor_can_edit?(subject)
    assessor_id == subject.id
  end

  def as_json
    if errors.blank?
      {}
    else
      { error: errors.full_messages }
    end
  end

  def valid_for_submission?
    struct.meths_for_award_type(form_answer).each do |meth|
      if public_send(meth).blank?
        return false
      end
    end

    true
  end

  private

  def admin?(subject)
    subject.is_a?(Admin)
  end

  def owner_or_administrative?(subject)
    admin?(subject) ||
      subject.assigned?(form_answer)
  end

  def not_submitted_or_not_locked?
    !submitted? || (submitted? && !locked?)
  end

  def mandatory_fields_for_submitted
    return if (!submitted? || !submission_action)

    struct.meths_for_award_type(form_answer).each do |meth|
      if public_send(meth).blank?
        errors.add(meth, "cannot be blank")
      end
    end
  end

  def validate_rate(rate_type)
    struct.rates(form_answer, rate_type).each do |section, _|
      val = section_rate(section)
      c = "#{rate_type.upcase}_ALLOWED_VALUES"
      if val && !struct.const_get(c).include?(val)
        sect_name = struct.rate(section)
        errors.add(sect_name, "#{rate_type} field has not permitted value")
      end
    end
  end

  def section_rate(section)
    public_send(struct.rate(section))
  end

  def struct
    AppraisalForm
  end

  def set_award_year!
    self.award_year = form_answer.award_year
  end
end
