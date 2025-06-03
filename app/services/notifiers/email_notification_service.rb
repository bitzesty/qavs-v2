class Notifiers::EmailNotificationService
  include ActionView::Helpers::SanitizeHelper
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
                   .pluck(:id)

    user_ids.each do |user_id|
      Users::AwardYearOpenNotificationMailer.notify(
        user_id
      ).deliver_now!
    end
  end

  def submission_started_notification(award_year, award_type)
    year_open_award_type_specific_notification(award_type)
  end

  def reminder_to_submit(award_year)
    scope = award_year.form_answers.where(submitted_at: nil)

    scope.each do |form_answer|
      AccountMailers::ReminderToSubmitMailer.notify(form_answer.id).deliver_now!
    end
  end

  def group_leader_notification(award_year)
    award_year.form_answers.submitted.each do |form_answer|
      AccountMailers::GroupLeaderMailer.notify(form_answer.id).deliver_now!
    end
  end

  def local_assessment_notification(award_year)
    ceremonial_counties = award_year.form_answers.submitted.pluck(:ceremonial_county_id).uniq

    lieutenant_ids = Lieutenant.all.where(ceremonial_county_id: ceremonial_counties, role: "advanced").pluck(:id)

    lieutenant_ids.each do |lieutenant_id|
      LieutenantsMailers::LocalAssessmentNotificationMailer.notify(lieutenant_id).deliver_now!
    end
  end

  def local_assessment_reminder(award_year)
    ceremonial_counties = award_year.form_answers.submitted.pluck(:ceremonial_county_id).uniq

    lieutenant_ids = Lieutenant.all.where(ceremonial_county_id: ceremonial_counties, role: "advanced").pluck(:id)

    lieutenant_ids.each do |lieutenant_id|
      LieutenantsMailers::LocalAssessmentReminderMailer.notify(lieutenant_id).deliver_now!
    end
  end

  # to 'Group Leaders' of winning nominations
  def winners_head_of_organisation_notification(award_year)
    winners = award_year.form_answers.winners

    gl_emails = winners.map do |w|
      # creating citations in one go as well
      w.build_citation(
        group_name: w.document["nomination_local_assessment_form_nominee_name"],
        body: sanitize(w.document["l_citation_summary"], tags: [])
      ).save!

      {
        id: w.id,
        email: w.document["local_assessment_group_leader_email"].downcase,
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

    # Reload the winners to get the updated group_leader associations
    winners = award_year.form_answers.winners.includes(:group_leader)

    winners_dictionary = winners.map do |entry|
      # Find the group leader by form_answer_id if the association is nil
      group_leader = entry.group_leader || GroupLeader.find_by(form_answer_id: entry.id)

      if group_leader
        {
          id: entry.id,
          group_leader_id: group_leader.id
        }
      end
    end.compact

    send_emails_to_group_leaders!(
      winners_dictionary,
      GroupLeadersMailers::WinnersHeadOfOrganisationMailer
    )
  end

  def unsuccessful_group_leaders_notification(award_year)
    award_year.form_answers.unsuccessful_applications_for_group_leader_mailer.each do |form_answer|
      GroupLeadersMailers::NotifyUnsuccessfulNominationsMailer.notify(form_answer.id).deliver_now!
    end
  end

  def winners_notification(award_year)
    award_year.form_answers.winners.each do |form_answer|
      AccountMailers::NotifySuccessfulNominationsMailer.notify(form_answer.id).deliver_now!
    end
  end

  def unsuccessful_notification(award_year)
    award_year.form_answers.unsuccessful_applications_for_nominator_mailer.each do |form_answer|
      AccountMailers::NotifyUnsuccessfulNominationsMailer.notify(form_answer.id).deliver_now!
    end
  end

  def buckingham_palace_invite(award_year)
   award_year.form_answers.winners.each do |form_answer|
    group_leader = GroupLeader.find_by_form_answer_id(form_answer.id)
    next unless group_leader

    GroupLeadersMailers::BuckinghamPalaceInviteMailer.invite(form_answer.id, group_leader.id).deliver_now!
    end
  end

  class << self
    def log_this(message)
      p "[EmailNotificationService] #{Time.zone.now} #{message}"
    end
  end

  private

  def send_emails_to_group_leaders!(data, mailer)
    data.each do |entry|
      mailer.notify(
        entry[:id],
        entry[:group_leader_id]
      ).deliver_now!
    end
  end

  def year_open_award_type_specific_notification(award_type)
    user_ids = User.confirmed
                   .allowed_to_get_award_open_notification(award_type)
                   .pluck(:id)

    user_ids.each do |user_id|
      Users::SubmissionStartedNotificationMailer.notify(
        user_id,
        award_type
      ).deliver_now!
    end
  end
end
