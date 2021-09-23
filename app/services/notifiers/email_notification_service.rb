class Notifiers::EmailNotificationService
  attr_reader :email_notifications

  def self.run
    log_this("started") unless Rails.env.test?

    new.run

    log_this("completed") unless Rails.env.test?
  end

  def initialize
    @email_notifications = AwardYear.current.settings.email_notifications.current.to_a
    if AwardYear.current != AwardYear.closed
      @email_notifications += AwardYear.closed.settings.email_notifications.current.to_a
    end
  end

  def run
    email_notifications.each do |notification|
      public_send(notification.kind, notification.settings.award_year)

      notification.update_column(:sent, true)
    end
  end

  def award_year_open_notifier(award_year)
    user_ids = User.confirmed
                   .not_bounced_emails
                   .want_to_receive_opening_notification_for_at_least_one_award
                   .pluck(:id)

    user_ids.each do |user_id|
      Users::AwardYearOpenNotificationMailer.notify(
        user_id
      ).deliver_later!
    end
  end

  def submission_started_notification(award_year, award_type)
    year_open_award_type_specific_notification(award_type)
  end

  def reminder_to_submit(award_year)
    collaborator_data = []
    scope = award_year.form_answers.where(submitted_at: nil)

    scope.each do |form_answer|
      form_answer.collaborators.each do |collaborator|
        if collaborator.notification_when_submission_deadline_is_coming?
          collaborator_data << { form_answer_id: form_answer.id, collaborator_id: collaborator.id }
        end
      end
    end

    send_emails_to_collaborators!(
      collaborator_data, AccountMailers::ReminderToSubmitMailer
    )
  end

  def reminder_to_submit(award_year)
    collaborator_data = []
    scope = award_year.form_answers.where(submitted_at: nil)

    scope.each do |form_answer|
      form_answer.collaborators.each do |collaborator|
        if collaborator.notification_when_submission_deadline_is_coming?
          collaborator_data << { form_answer_id: form_answer.id, collaborator_id: collaborator.id }
        end
      end
    end

    send_emails_to_collaborators!(
      collaborator_data, AccountMailers::ReminderToSubmitMailer
    )
  end

  def group_leader_notification(award_year)
    submitted_nominations = award_year.form_answers.submitted
    group_leaders = {}

    submitted_nominations.each do |nomination|
      name = nomination.document["nominee_leader_name"]
      email = nomination.document["nominee_leader_email"]
      group_name = nomination.document["nominee_name"]
      # making sure we only send 1 email per email
      group_leaders[email] = { name: name, group_name: group_name }
    end

    group_leaders.each do |email, v|
      AccountMailers::GroupLeaderMailer.notify(email, v[:name], v[:group_name]).deliver_later!
    end
  end

  def local_assessment_notification(award_year)
    ceremonial_counties = award_year.form_answers.submitted.pluck(:ceremonial_county_id).uniq

    lieutenant_ids = Lieutenant.all.where(ceremonial_county_id: ceremonial_counties, role: "advanced").pluck(:id)

    lieutenant_ids.each do |lieutenant_id|
      LieutenantsMailers::LocalAssessmentNotificationMailer.notify(lieutenant_id).deliver_later!
    end
  end

  def local_assessment_reminder(award_year)
    ceremonial_counties = award_year.form_answers.submitted.pluck(:ceremonial_county_id).uniq

    lieutenant_ids = Lieutenant.all.where(ceremonial_county_id: ceremonial_counties, role: "advanced").pluck(:id)

    lieutenant_ids.each do |lieutenant_id|
      LieutenantsMailers::LocalAssessmentReminderMailer.notify(lieutenant_id).deliver_later!
    end
  end

  def shortlisted_notifier(award_year)
    gather_data_and_send_emails!(
      award_year.form_answers.shortlisted,
      AccountMailers::NotifyShortlistedMailer
    )
  end

  def not_shortlisted_notifier(award_year)
    gather_data_and_send_emails!(
      award_year.form_answers.not_shortlisted,
      AccountMailers::NotifyNonShortlistedMailer
    )
  end

  def shortlisted_audit_certificate_reminder(award_year)
    collaborator_data = []

    award_year.form_answers.shortlisted.each do |form_answer|
      next if form_answer.audit_certificate && form_answer.list_of_procedures

      form_answer.collaborators.each do |collaborator|
        collaborator_data << { form_answer_id: form_answer.id, collaborator_id: collaborator.id }
      end
    end

    send_emails_to_collaborators!(collaborator_data, Users::AuditCertificateRequestMailer)
  end

  # to 'Group Leaders' of winning nominations
  def winners_head_of_organisation_notification(award_year)
    winners = award_year.form_answers.winners

    gl_emails = winners.map do |w|
      # creating citations in one go as well
      w.build_citation(
        group_name: w.document["nomination_local_assessment_form_nominee_name"],
        body: w.document["l_citation_summary"]
      ).save!

      {
        id: w.id,
        email: w.document["local_assessment_group_leader_email"],
        first_name: w.group_leader_first_name,
        last_name: w.group_leader_last_name
      }
    end
    gl_emails.each do |attrs|
      next if GroupLeader.where(email: attrs[:email]).exists?

      GroupLeader.create!(
        email: attrs[:email],
        first_name: attrs[:first_name],
        last_name: attrs[:last_name],
        skip_password_validation: true,
        form_answer_id: attrs[:id]
      )
    end

    send_emails_to_group_leaders!(
      winners,
      GroupLeadersMailers::WinnersHeadOfOrganisationMailer
    )
  end

  def unsuccessful_notification(award_year)
    gather_data_and_send_emails!(
      award_year.form_answers.unsuccessful_applications,
      AccountMailers::UnsuccessfulFeedbackMailer
    )
  end

  def winners_notification(award_year)
    winners = award_year.form_answers.winners

    gl_emails = winners.map do |w|
      # creating citations in one go as well
      w.build_citation(
        group_name: w.document["nomination_local_assessment_form_nominee_name"],
        body: w.document["l_citation_summary"]
      ).save!

      {
        id: w.id,
        email: w.document["local_assessment_group_leader_email"],
        first_name: w.group_leader_first_name,
        last_name: w.group_leader_last_name
      }
    end

    gl_emails.each do |attrs|
      next if GroupLeader.where(email: attrs[:email]).exists?

      gl = GroupLeader.create!(
        email: attrs[:email],
        first_name: attrs[:first_name],
        last_name: attrs[:last_name],
        skip_password_validation: true,
        form_answer_id: attrs[:id]
      )
    end

    send_emails_to_group_leaders!(
      award_year.form_answers.winners,
      AccountMailers::GroupLeaderInviteMailer
    )
  end

  def buckingham_palace_invite(award_year)
    form_answer_ids = []

    award_year.form_answers.winners.each do |form_answer|

      invite = PalaceInvite.where(
        email: form_answer.decorate.head_email,
        form_answer_id: form_answer.id
      ).first_or_create

      unless invite.submitted?
        form_answer_ids << form_answer.id
      end
    end

    form_answer_ids.each do |form_answer_id|
      #
      # 1: to Head of Organization
      AccountMailers::BuckinghamPalaceInviteMailer.invite(form_answer_id).deliver_later!
      #
      # 2: to Press Contact
      AccountMailers::BuckinghamPalaceInviteMailer.invite(form_answer_id, true).deliver_later!
    end
  end

  class << self
    def log_this(message)
      p "[EmailNotificationService] #{Time.zone.now} #{message}"
    end
  end

  private

  def formatted_collaborator_data(scope)
    collaborator_data = []

    scope.each do |form_answer|
      form_answer.collaborators.each do |collaborator|
        collaborator_data << { form_answer_id: form_answer.id, collaborator_id: collaborator.id }
      end
    end

    collaborator_data
  end

  def gather_data_and_send_emails!(scope, mailer)
    collaborator_data = formatted_collaborator_data(scope)
    send_emails_to_collaborators!(collaborator_data, mailer)
  end

  def send_emails_to_collaborators!(data, mailer)
    data.each do |entry|
      mailer.notify(
        entry[:form_answer_id],
        entry[:collaborator_id]
      ).deliver_later!
    end
  end

  def send_emails_to_group_leaders!(data, mailer)
    data.includes(:group_leader).each do |entry|
      mailer.notify(
        entry.id,
        entry.group_leader.id
      ).deliver_later!
    end
  end

  def year_open_award_type_specific_notification(award_type)
    user_ids = User.confirmed
                   .not_bounced_emails
                   .allowed_to_get_award_open_notification(award_type)
                   .pluck(:id)

    user_ids.each do |user_id|
      Users::SubmissionStartedNotificationMailer.notify(
        user_id,
        award_type
      ).deliver_later!
    end
  end
end
