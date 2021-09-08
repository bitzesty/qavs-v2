class Admin::SettingsController < Admin::BaseController
  before_action :load_email_notifications, only: [:show]

  def show
    authorize :setting, :show?
  end

  def bulk_award_nominations
    authorize :setting, :show?

    FormAnswer.transaction do
      ids = @settings
              .award_year
              .form_answers
              .shortlisted
              .pluck(:id)

      AdminVerdict
        .where(form_answer_id: ids)
        .update_all(outcome: "awarded")

      FormAnswer
        .where(id: ids)
        .update_all(state: "awarded")
    end

    redirect_to admin_settings_path(year: @settings.award_year.year),
                success_template: "bulk_award_success"
  end

  private

  def load_email_notifications
    @email_notifications = @settings.email_notifications.order(:trigger_at).to_a
  end
end
