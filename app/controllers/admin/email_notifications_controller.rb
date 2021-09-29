class Admin::EmailNotificationsController < Admin::BaseController
  before_action :load_email_notification, only: [:update, :destroy]

  def create
    authorize :email_notification, :create?
    @email_notification = @settings.email_notifications.build
    @email_notification.update(notification_params)
    @email_notifications = @settings.email_notifications

    respond_to do |format|
      format.html do
        if @email_notification.valid?
          flash.notice = "Notification successfully created"
          redirect_to admin_settings_path
        else
          flash.alert = "Notification was not created"
          render "admin/settings/show"
        end
      end

      format.js
    end
  end

  def update
    authorize @email_notification, :update?
    @email_notification.update(notification_params)

    respond_to do |format|
      format.html do
        if @email_notification.valid?
          flash.notice = "Notification successfully updated"
          redirect_to admin_settings_path
        else
          flash.alert = "Notification was not updated"
          render "admin/settings/show"
        end
      end

      format.js
    end
  end

  def destroy
    authorize @email_notification, :destroy?
    @email_notification.destroy

    respond_to do |format|
      format.html do
        flash.notice = "Notification successfully destroyed"
        redirect_to admin_settings_path
      end

      format.js
    end
  end

  def run_notifications
    authorize :email_notification, :create?

    if ::ServerEnvironment.local_or_dev_or_staging_server?
      ::Notifiers::EmailNotificationService.run
    end

    redirect_to admin_settings_path
  end

  private

  def load_email_notification
    @email_notification = @settings.email_notifications.find(params[:id])
  end

  def notification_params
    params.require(:email_notification).permit([:trigger_at_day,
                                                :trigger_at_month,
                                                :trigger_at_year,
                                                :trigger_at_time,
                                                :kind])
  end
end
