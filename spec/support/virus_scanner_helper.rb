# Helper for tests involving file scanning
module VirusScannerHelper
  # Set up mocks for the virus scanner
  def setup_scanner_mocks
    # Instead of creating a shared double, we'll stub the Rails.logger method
    allow(Rails).to receive(:logger).and_return(null_logger)

    # If there's a specific scanner class, mock it too
    if defined?(ClamScan)
      allow_any_instance_of(ClamScan).to receive(:file_infected?).and_return(false)
    end

    # Mock specific models that use file scanning
    if defined?(FormAnswerAttachment)
      allow_any_instance_of(FormAnswerAttachment).to receive(:scan_file!).and_return(true)
      allow_any_instance_of(FormAnswerAttachment).to receive(:scan_file_without_cleanup!).and_return(true)
    end

    if defined?(SupportLetterAttachment)
      allow_any_instance_of(SupportLetterAttachment).to receive(:scan_attachment!).and_return(true)
      allow_any_instance_of(SupportLetterAttachment).to receive(:scan_attachment_without_cleanup!).and_return(true)
    end
  end

  # A null logger that swallows all messages
  def null_logger
    logger = Object.new

    def logger.info(message = nil)
      true
    end

    def logger.error(message = nil)
      true
    end

    def logger.debug(message = nil)
      true
    end

    logger
  end
end

RSpec.configure do |config|
  config.include VirusScannerHelper

  # Set up scanner mocks for all tests
  config.before(:each) do
    setup_scanner_mocks
  end
end
