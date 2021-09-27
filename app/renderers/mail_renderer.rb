class MailRenderer
  class View < ActionView::Base
    extend ApplicationHelper
    include ActionView::Helpers
    include Rails.application.routes.url_helpers

    def default_url_options
      {
        host: "apply.qavs.dcms.gov.uk",
        protocol: "https"
      }
    end
  end

  def submission_started_notification
    #
    # NOTE: This one is old.
    #       But we still need it here in order to show it for previous years
    #
    assigns = {}

    assigns[:user] = dummy_user("Jon", "Doe", "Jane's Company")
    assigns[:award_type] = "International Trade"

    render(assigns, "users/submission_started_notification_mailer/preview/notify")
  end

  def award_year_open_notifier
    assigns = {}

    assigns[:user] = dummy_user("Jon", "Doe", "Jane's Company")

    render(assigns, "users/award_year_open_notification_mailer/preview/notify")
  end

  def ep_reminder_support_letters
    assigns = {}

    assigns[:user] = dummy_user("Jon", "Doe", "Jane's Company")
    assigns[:form_answer] = form_answer
    assigns[:days_before_submission] = "N"
    assigns[:deadline] = deadline_str("submission_end")
    assigns[:nominee_name] = "Jane Doe"

    render(assigns, "account_mailers/promotion_letters_of_support_reminder_mailer/preview/notify")
  end

  def reminder_to_submit
    assigns = {}

    assigns[:user] = dummy_user("Jon", "Doe", "Jane's Company")
    assigns[:form_answer] = form_answer
    assigns[:deadline] = Settings.current_submission_deadline.decorate.long_mail_reminder

    render(assigns, "account_mailers/reminder_to_submit_mailer/preview/notify")
  end

  def group_leader_notification
    assigns = {}

    assigns[:group_leader_name] = "Jane Campton"
    assigns[:group_name] = "Endeavour"
    assigns[:form_answer] = form_answer

    render(assigns, "account_mailers/group_leader_mailer/preview/notify")
  end

  def local_assessment_notification
    assigns = {}

    assigns[:lieutenant] = dummy_lieutenant
    assigns[:total] = 5
    render(assigns, "lieutenants_mailers/local_assessment_notification_mailer/preview/notify")
  end

  def local_assessment_reminder
    assigns = {}

    assigns[:lieutenant] = dummy_lieutenant
    assigns[:deadline] = Settings.current_local_assessment_submission_deadline.decorate.long_mail_reminder

    render(assigns, "lieutenants_mailers/local_assessment_reminder_mailer/preview/notify")
  end

  def not_shortlisted_notifier
    assigns = {}

    assigns[:user] = dummy_user("Jon", "Doe", "John's Company")
    assigns[:current_year] = AwardYear.current.year
    render(assigns, "account_mailers/notify_non_shortlisted_mailer/preview/notify")
  end

  def shortlisted_notifier
    assigns = {}

    assigns[:user] = dummy_user("Jon", "Doe", "John's Company")
    assigns[:form_answer] = form_answer
    assigns[:company_name] = "Massive Dynamic"


    assigns[:deadline_time] = deadline_str("audit_certificates", "%H:%M")
    assigns[:deadline_date] = deadline_str("audit_certificates")

    render(assigns, "account_mailers/notify_shortlisted_mailer/preview/notify")
  end

  def winners_head_of_organisation_notification
    assigns = {}
    form = form_answer
    group_leader = dummy_group_leader

    assigns[:group_leader_name] = "#{ group_leader.first_name } #{ group_leader.last_name }"
    assigns[:form_answer] = form
    assigns[:award_year] = form.award_year.year
    assigns[:group_name] = "Synergy"
    assigns[:token] = "securetoken"
    assigns[:end_of_embargo_date] = deadline_str("buckingham_palace_attendees_details", "%-d %B")
    assigns[:citation_deadline] = deadline_str("buckingham_palace_confirm_press_book_notes", "%-d %B")

    render(assigns, "group_leaders_mailers/winners_head_of_organisation_mailer/preview/notify")
  end

  def unsuccessful_group_leaders_notification
    assigns = {}
    form = form_answer

    assigns[:group_leader_name] = "John Smith"
    assigns[:form_answer] = form
    assigns[:award_year] = form.award_year.year
    assigns[:group_name] = "Massive Dynamic"

    render(assigns, "group_leaders_mailers/notify_unsuccessful_nominations_mailer/preview/notify")
  end

  def winners_notification
    assigns = {}

    assigns[:group_name] = "Synergy"
    assigns[:end_of_embargo_date] = deadline_str("buckingham_palace_attendees_details", "%-d %B")

    render(assigns, "account_mailers/notify_successful_nominations_mailer/preview/notify")
  end

  def unsuccessful_notification
    assigns = {}

    assigns[:form_answer] = form_answer
    assigns[:group_name] = "Massive Dynamic"

    render(assigns, "account_mailers/notify_unsuccessful_nominations_mailer/preview/notify")
  end

  def buckingham_palace_invite
    assigns = {}
    form = form_answer
    group_leader = dummy_group_leader

    assigns[:group_leader_name] = "#{ group_leader.first_name } #{ group_leader.last_name }"
    assigns[:form_answer] = form
    assigns[:award_year] = form.award_year.year

    palace_attendees_due = AwardYear.buckingham_palace_reception_attendee_information_due_by
    palace_attendees_due = DateTime.new(Date.current.year, 5, 6, 00, 00) if palace_attendees_due.blank?

    assigns[:palace_attendees_due] = palace_attendees_due.strftime(
      "%A, #{palace_attendees_due.day.ordinalize} %B %Y"
    )

    render(assigns, "group_leaders_mailers/buckingham_palace_invite_mailer/preview/invite")
  end

  private

  def render(assigns, template)
    view = View.new(ActionView::LookupContext.new(ActionController::Base.view_paths), assigns)
    view.render(template: template)
  end

  def dummy_user(first_name, last_name, company_name)
    User.new(first_name: first_name, last_name: last_name, company_name: company_name).decorate
  end

  def dummy_group_leader(first_name = "Jane", last_name = "Doe")
    GroupLeader.new(first_name: first_name, last_name: last_name).decorate
  end

  def dummy_lieutenant(first_name = "Jay", last_name = "Doe")
    Lieutenant.new(first_name: first_name, last_name: last_name, ceremonial_county_id: 1).decorate
  end

  def form_answer
    @form_answer ||= FormAnswer.new(
      id: 0,
      urn: "QA0128/16I",
      award_year: AwardYear.current,
    ).decorate
  end

  def deadline_str(kind, format = "%d/%m/%Y")
    d = deadline(kind)

    if d.present?
      d.strftime(format)
    else
      DateTime.new(Date.current.year, 9, 21, 10, 30).strftime(format)
    end
  end

  def deadline(kind)
    Settings.current.deadlines.find_by(
      kind: kind
    ).try :trigger_at
  end
end
