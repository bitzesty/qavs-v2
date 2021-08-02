# config/initializers/cloudtasker.rb

Cloudtasker.configure do |config|
  #
  # If you do not have any Rails secret_key_base defined, uncomment the following.
  # This secret is used to authenticate jobs sent to the processing endpoint
  # of your application.
  #
  # Default with Rails: Rails.application.credentials.secret_key_base
  #
  config.secret = Rails.application.credentials.secret_key_base || 'testing'

  #
  # Specify the details of your Google Cloud Task location.
  #
  # This not required in development using the Cloudtasker local server.
  #
  config.gcp_location_id = 'eu-west2' # defaults to 'us-east1'
  config.gcp_project_id = 'new-qavs'

  #
  # Specify the namespace for your Cloud Task queues.
  #
  # The gem assumes that a least a default queue named 'my-app-default'
  # exists in Cloud Tasks. You can create this default queue using the
  # gcloud SDK or via the `rake cloudtasker:setup_queue` task if you use Rails.
  #
  # Workers can be scheduled on different queues. The name of the queue
  # in Cloud Tasks is always assumed to be prefixed with the prefix below.
  #
  # E.g.
  # Setting `cloudtasker_options queue: 'critical'` on a worker means that
  # the worker will be pushed to 'my-app-critical' in Cloud Tasks.
  #
  # Specific queues can be created in Cloud Tasks using the gcloud SDK or
  # via the `rake cloudtasker:setup_queue name=<queue_name>` task.
  #
  config.gcp_queue_prefix = ENV["GCP_QUEUE_PREFIX"]

  #
  # Specify the publicly accessible host for your application
  #
  # > E.g. in development, using the cloudtasker local server
  # config.processor_host = 'http://localhost:3000'
  #
  # > E.g. in development, using `config.mode = :production` and ngrok
  # config.processor_host = 'https://111111.ngrok.io'
  #
  config.processor_host = Rails.env.production? ? QAE.env : 'http://localhost:3000'

  #
  # Specify the mode of operation:
  # - :development => jobs will be pushed to Redis and picked up by the Cloudtasker local server
  # - :production => jobs will be pushed to Google Cloud Tasks. Requires a publicly accessible domain.
  #
  # Defaults to :development unless CLOUDTASKER_ENV or RAILS_ENV or RACK_ENV is set to something else.
  #
  config.mode = Rails.env.production? ? :production : :development

  #
  # Specify the logger to use
  #
  # Default with Rails: Rails.logger
  # Default without Rails: Logger.new(STDOUT)
  #
  # config.logger = MyLogger.new(STDOUT)

  #
  # Specify how many retries are allowed on jobs. This number of retries excludes any
  # connectivity error due to the application being down or unreachable.
  #
  # Default: 25
  #
  config.max_retries = 1

  #
  # Specify the redis connection hash.
  #
  # This is ONLY required in development for the Cloudtasker local server and in
  # all environments if you use any cloudtasker extension (unique jobs, cron jobs or batch jobs)
  #
  # See https://github.com/redis/redis-rb for examples of configuration hashes.
  #
  # Default: redis-rb connects to redis://127.0.0.1:6379/0
  #
  config.redis = { url: ENV['REDIS_URL'] }

  if Rails.env.production?
    default_schedule = {
      "email_notification_service" => {
        "cron" => "0 * * * *",
        "worker" => "Scheduled::EmailNotificationServiceWorker"
      },
      "trigger_audit_deadlines" => {
        "cron" => "0 * * * *",
        "worker" => "Scheduled::AuditDeadlineWorker"
      },
      "trigger_submission_deadlines" => {
        "cron" => "0 * * * *",
        "worker" => "Scheduled::SubmissionDeadlineWorker"
      },
      "form_data_pdf_hard_copy_generation_service" => {
        "cron" => "30 0 * * *",
        "worker" => "HardCopyPdfGenerators::Collection::FormDataWorker"
      },
      "case_summary_pdf_hard_copy_generation_service" => {
        "cron" => "30 2 * * *",
        "worker" => "HardCopyPdfGenerators::Collection::CaseSummaryWorker"
      },
      "feedback_pdf_hard_copy_generation_service" => {
        "cron" => "30 4 * * *",
        "worker" => "HardCopyPdfGenerators::Collection::FeedbackWorker"
      },
      "aggregated_case_summary_pdf_hard_copy_generation_service" => {
        "cron" => "10 5 * * *",
        "worker" => "HardCopyPdfGenerators::Aggregated::CaseSummariesWorker"
      },
      "aggregated_feedback_pdf_hard_copy_generation_service" => {
        "cron" => "30 5 * * *",
        "worker" => "HardCopyPdfGenerators::Aggregated::FeedbacksWorker"
      },
      "debounce_check_service" => {
        "cron" => "50 5 * * *",
        "worker" => "Scheduled::DebounceApiScanWorker"
      },
      "rescan_service" => {
        "cron" => "30 1 * * *",
        "worker" => "Scheduled::RescanServiceWorker"
      }
    }

    Cloudtasker::Cron::Schedule.load_from_hash!(default_schedule)

  end

  #
  # Set to true to store job arguments in Redis instead of sending arguments as part
  # of the job payload to Google Cloud Tasks.
  #
  # This is useful if you expect to process jobs with payloads exceeding 100KB, which
  # is the limit enforced by Google Cloud Tasks.
  #
  # You can set this configuration parameter to a KB value if you want to store jobs
  # args in redis only if the JSONified arguments payload exceeds that threshold.
  #
  # Supported since: v0.10.0
  #
  # Default: false
  #
  # Store all job payloads in Redis:
  # config.store_payloads_in_redis = true
  #
  # Store all job payloads in Redis exceeding 50 KB:
  # config.store_payloads_in_redis = 50

  #
  # Specify the dispatch deadline for jobs in Cloud Tasks, in seconds.
  # Jobs taking longer will be retried by Cloud Tasks, even if they eventually
  # complete on the server side.
  #
  # Note that this option is applied when jobs are enqueued job. Changing this value
  # will not impact already enqueued jobs.
  #
  # This option can also be configured on a per worker basis via
  # the cloudtasker_options directive.
  #
  # Supported since: v0.12.rc8
  #
  # Default: 600 seconds (10 minutes)
  #
  # config.dispatch_deadline = 600

  #
  # Specify a proc to be invoked every time a job fails due to a runtime
  # error.
  #
  # This hook is not invoked for DeadWorkerError. See on_dead instead.
  #
  # This is useful when you need to apply general exception handling, such
  # as reporting errors to a third-party service like Rollbar or Bugsnag.
  #
  # Note: the worker argument might be nil, such as when InvalidWorkerError is raised.
  #
  # Supported since: v0.12.rc11
  #
  # Default: no operation
  #
  config.on_error = ->(error, worker) { Appsignal.set_error(error) }

  #
  # Specify a proc to be invoked every time a job dies due to too many
  # retries.
  #
  # This is useful when you need to apply general exception handling, such
  # logging specific messages/context when a job dies.
  #
  # Supported since: v0.12.rc11
  #
  # Default: no operation
  #
  config.on_dead = ->(error, worker) { Appsignal.set_error(error) }
end