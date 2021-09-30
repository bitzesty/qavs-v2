module Scheduled
  class BaseWorker
    include Sidekiq::Worker
  end
end
