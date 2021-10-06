module HardCopyPdfGenerators
  class BaseWorker
    include Sidekiq::Worker
  end
end
