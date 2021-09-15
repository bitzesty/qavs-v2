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

  def unsuccessful_notification
    assigns = {}

    assigns[:name] = "Mr Smith"
    assigns[:user] = dummy_user("Jon", "Doe", "Jane's Company")
    assigns[:form_answer] = form_answer
    assigns[:year] = AwardYear.closed.year
    form_answer.urn = "QA0001/16I"

    render(assigns, "account_mailers/unsuccessful_feedback_mailer/preview/notify")
  end

  def unsuccessful_ep_notification
    assigns = {}

    assigns[:user] = dummy_user("Jon", "Doe", "Jane's Company")
    assigns[:form_answer] = form_answer
    assigns[:nominee_name] = "Nominee Name"
    assigns[:year] = AwardYear.closed.year
    form_answer.urn = "QA0128/16EP"

    render(assigns, "account_mailers/unsuccessful_feedback_mailer/preview/ep_notify")
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
    assigns[:deadline] = deadline_str("submission_end", "%A %d %B %Y")

    render(assigns, "account_mailers/reminder_to_submit_mailer/preview/notify")
  end

  def group_leader_notification
    assigns = {}

    assigns[:group_leader_name] = "Jane Campton"
    assigns[:form_answer] = form_answer

    render(assigns, "account_mailers/group_leader_mailer/preview/notify")
  end

  def local_assessment_notification
    assigns = {}

    assigns[:lieutenant] = dummy_lieutenant

    render(assigns, "lieutenants_mailers/local_assessment_notification_mailer/preview/notify")
  end

  def local_assessment_reminder
    assigns = {}

    assigns[:lieutenant] = dummy_lieutenant
    assigns[:deadline] = deadline_str("local_assessment_submission_end", "%A %d %B %Y")

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

  def winners_notification
    assigns = {}

    assigns[:group_name] = "Everyday Charity"
    assigns[:group_leader] = dummy_group_leader("Jane", "Doe")
    assigns[:token] = "tpscrttkn"
    assigns[:year] = form_answer.award_year.year

    # assigns[:deadline] = deadline("buckingham_palace_attendees_details")
    # assigns[:media_deadline] = deadline_str(
    #   "buckingham_palace_media_information",
    #   "%A %d %B %Y"
    # )
    # assigns[:book_notes_deadline] = deadline_str(
    #   "buckingham_palace_confirm_press_book_notes",
    #   "%A %d %B %Y"
    # )

    render(assigns, "account_mailers/group_leader_invite_mailer/preview/notify")
  end

  def winners_head_of_organisation_notification
    assigns = {}
    form = form_answer

    assigns[:name] = "Mr Smith"
    assigns[:form_answer] = form
    assigns[:award_year] = form.award_year.year
    assigns[:urn] = "QAXXXX/#{assigns[:award_year].to_s[2..-1]}I"
    assigns[:head_email] = "john@example.com"
    assigns[:head_of_business_full_name] = "Jon Doe"

    assigns[:end_of_embargo_day] = deadline_str("buckingham_palace_attendees_details", "%A %-d %B %Y")
    assigns[:end_of_embargo_date] = deadline_str("buckingham_palace_attendees_details", "%-d %B %Y")
    assigns[:press_book_entry_datetime] = deadline_str("buckingham_palace_confirm_press_book_notes", "%d %B %Y")

    assigns[:media_deadline] = deadline_str(
      "buckingham_palace_media_information",
      "%A %d %B %Y"
    )

    render(assigns, "users/winners_head_of_organisation_mailer/preview/notify")
  end

  def buckingham_palace_invite
    assigns = {}

    assigns[:form_answer] = form_answer
    assigns[:name] = "John Smith"
    assigns[:token] = "securetoken"

    reception_date = AwardYear.buckingham_palace_reception_date
    reception_date = DateTime.new(Date.current.year, 7, 11, 18, 00) if reception_date.blank?

    assigns[:reception_date] = reception_date.strftime(
      "%A #{reception_date.day.ordinalize} %B %Y"
    )

    palace_attendees_due = AwardYear.buckingham_palace_reception_attendee_information_due_by
    palace_attendees_due = DateTime.new(Date.current.year, 5, 6, 00, 00) if palace_attendees_due.blank?

    assigns[:palace_attendees_due] = palace_attendees_due.strftime(
      "%A, #{palace_attendees_due.day.ordinalize} %B %Y"
    )

    render(assigns, "account_mailers/buckingham_palace_invite_mailer/preview/invite")
  end

  private

  def render(assigns, template)
    view = View.new(ActionView::LookupContext.new(ActionController::Base.view_paths), assigns)
    view.render(template: template)
  end

  def dummy_user(first_name, last_name, company_name)
    User.new(first_name: first_name, last_name: last_name, company_name: company_name).decorate
  end

  def dummy_group_leader(first_name, last_name)
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
