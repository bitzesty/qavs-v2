require "rails_helper"

describe RescanService do
  describe ".perform" do
    it "triggers rescan on attachment models" do
      expect(described_class).to receive(:rescan_model).with(SupportLetterAttachment, :attachment)
      expect(described_class).to receive(:rescan_model).with(FormAnswerAttachment, :file)
      described_class.perform
    end
  end

  describe ".rescan_model" do
    let!(:form_answer) { create(:form_answer) }
    let!(:attachment) { create(:form_answer_attachment, form_answer: form_answer) }

    it "rescans unresolved files" do
      attachment.file_scan_results = "scanning"
      attachment.save!

      # Mock the scan_file! method to change the scan results to clean
      expect_any_instance_of(FormAnswerAttachment).to receive(:scan_file!).and_wrap_original do |original, *args|
        original.receiver.update_column(:file_scan_results, "clean")
        true
      end

      described_class.rescan_model(FormAnswerAttachment, :file)
      expect(attachment.reload.file_scan_results).to eq('clean')
    end

    it "does not rescan clean files" do
      attachment.file_scan_results = "clean"
      attachment.save!
      expect(attachment).not_to receive(:scan_file!)
      described_class.rescan_model(FormAnswerAttachment, :file)
    end
  end
end
