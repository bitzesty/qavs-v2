class FormAnswerSearch < Search
  attr_reader :subject

  def self.default_search
    {
      sort: 'company_or_nominee_name',
      search_filter: {
        status: FormAnswerStatus::AdminFilter.all,
        activity_type: FormAnswerStatus::AdminFilter.values('activity'),
        assigned_ceremonial_county: FormAnswerStatus::AdminFilter.values('assigned county'),
        nominated_ceremonial_county: FormAnswerStatus::AdminFilter.values('nominated county')
      }
    }
  end

  def initialize(scope, subject)
    @subject = subject
    super(scope)
  end

  # admin comments with flags + global flag per application
  def sort_by_flag(scoped_results, desc = false)
    section = (@subject.is_a?(Admin) ? "admin" : "critical")
    section = Comment.sections[section]

    q = "form_answers.*,
      (COUNT(flagged_comments.id)) AS flags_count"
    scoped_results.select(q)
      .joins("LEFT OUTER JOIN comments  AS flagged_comments on (flagged_comments.commentable_id=form_answers.id) AND ((flagged_comments.section = '#{section}' AND flagged_comments.commentable_type = 'FormAnswer' AND flagged_comments.flagged = true) OR flagged_comments.section IS NULL)")
      .group("form_answers.id")
      .order("flags_count #{sort_order(desc)}")
  end

  def sort_by_sic_code(scoped_results, desc = false)
    scoped_results.order("(form_answers.document #>> '{sic_code}') #{sort_order(desc)}")
  end

  def sort_by_primary_assessor_name(scoped_results, desc = false)
    scoped_results
  end

  def sort_by_secondary_assessor_name(scoped_results, desc = false)
    scoped_results
  end

  def sort_by_audit_updated_at(scoped_results, desc = false)
    scoped_results
      .joins("LEFT OUTER JOIN (SELECT audit_logs.auditable_id, audit_logs.auditable_type, MAX(audit_logs.created_at) latest_audit_date FROM audit_logs
       WHERE audit_logs.action_type != 'download_form_answer'
       GROUP BY audit_logs.auditable_id, audit_logs.auditable_type) max_audit_dates ON max_audit_dates.auditable_id = form_answers.id AND max_audit_dates.auditable_type = 'FormAnswer'")
      .order("COALESCE(max_audit_dates.latest_audit_date, TO_DATE('20101031', 'YYYYMMDD')) #{sort_order(desc)}")
      .group("max_audit_dates.latest_audit_date")
  end

  def filter_by_status(scoped_results, value)
    scoped_results.where(state: filter_klass.internal_states(value))
  end

  def filter_by_activity_type(scoped_results, value)
    scoped_results.where(nominee_activity: value).or(scoped_results.where(secondary_activity: value))
  end

  def filter_by_assigned_ceremonial_county(scoped_results, value)
    value = value.map do |v|
      v == "not_assigned" ? nil : v
    end
    scoped_results.where(ceremonial_county_id: value)
  end

  def filter_by_nominated_ceremonial_county(scoped_results, value)
    county_filter_query = scoped_results.where("(form_answers.document #>> '{ nominee_ceremonial_county }') IN (?)", value)
    if value.include?("not_stated")
      scoped_results.where("(form_answers.document -> 'nominee_ceremonial_county') IS NULL").or(county_filter_query)
    else
      county_filter_query
    end
  end

  def filter_by_sub_status(scoped_results, value)
    out = scoped_results

    value.each do |v|
      case v
      when "lord_lieutenancy_not_assigned"
        out = out.where(ceremonial_county_id: nil)
      when "local_assessment_not_started"
        out = out.where(state: :admin_eligible).where.not(ceremonial_county_id: nil)
      when "assessors_not_assigned"
        out = out.where(sub_group: nil)
      when "national_assessment_outcome_pending"
        out = out.joins(
          "LEFT OUTER JOIN admin_verdicts ON admin_verdicts.form_answer_id = form_answers.id"
        ).where("admin_verdicts IS NULL")
      when "citation_not_submitted"
        out = out.joins(
          "LEFT OUTER JOIN citations ON citations.form_answer_id = form_answers.id"
        ).where("citations.completed_at IS NULL")
      when "missing_rsvp_details"
        out = out.joins(
          "LEFT OUTER JOIN palace_invites on palace_invites.form_answer_id = form_answers.id"
        ).where("palace_invites.submitted IS NOT TRUE")
      end
    end

    out
  end

  private

  def post_submission_states_for_sql
    quoted_states = FormAnswerStateMachine::POST_SUBMISSION_STATES.map { |s| "'#{s}'"}

    "(#{quoted_states.join(', ')})"
  end

  def filter_klass
    if subject.is_a?(Admin)
      FormAnswerStatus::AdminFilter
    elsif subject.is_a?(Assessor)
      FormAnswerStatus::AssessorFilter
    else
      FormAnswerStatus::LieutenantFilter
    end
  end
end
