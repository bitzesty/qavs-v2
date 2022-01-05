default_schedule = {
  "email_notification_service" => {
    "cron" => "*/30 * * * *",
    "class" => "Scheduled::EmailNotificationServiceWorker"
  },
  "trigger_submission_deadlines" => {
    "cron" => "0 * * * *",
    "class" => "Scheduled::SubmissionDeadlineWorker"
  },
  "form_data_pdf_hard_copy_generation_service" => {
    "cron" => "30 0 * * *",
    "class" => "HardCopyPdfGenerators::Collection::FormDataWorker"
  },
  "rescan_service" => {
    "cron" => "30 1 * * *",
    "class" => "Scheduled::RescanServiceWorker"
  }
}

Sidekiq.configure_server do |config|
  config.on(:startup) do
    Sidekiq::Cron::Job.load_from_hash(default_schedule)
  end
end
