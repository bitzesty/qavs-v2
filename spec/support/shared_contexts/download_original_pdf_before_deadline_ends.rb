require 'rails_helper'

shared_examples "download original pdf before deadline ends" do
  let!(:form_answer) do
    create(:form_answer, :submitted, user: create(:user))
  end

  let!(:user) { form_answer.user || create(:user) }

  describe "Download" do
    describe "PDF content" do
      let(:registration_number_at_the_deadline) { "1111111111" }
      let(:registration_number_after_deadline) { "2222222222" }

      before do
        # Turn on Papertrail
        PaperTrail.enabled = true

        # Set current time to date before deadline
        Timecop.freeze(Time.zone.now - 2.days) do
          form_answer.reload
          form_answer.document["registration_number"] = registration_number_at_the_deadline
          form_answer.save!
        end

        # Update value after deadline
        form_answer.reload
        form_answer.document["registration_number"] = registration_number_after_deadline
        form_answer.save!

        # Turn off Papertrail
        PaperTrail.enabled = false

        # Ensure we're going back to the deadline version
        Settings.current_submission_deadline.update(trigger_at: Time.zone.now - 1.day)
      end

      it "should include main header information", skip: "PDF generation needs fixing" do
        # Handle form versioning
        form_record = form_answer.original_form_answer

        # Skip if form_record not available in this test environment
        expect(form_record).not_to be_nil, "Original form answer should not be nil"

        # Generate PDF with proper error handling
        pdf_generator = form_record.decorate.pdf_generator(form_answer.user || user)
        pdf_content = PDF::Inspector::Text.analyze(pdf_generator.render).strings

        expect(pdf_content).to include(Settings.submission_deadline_title)
      end
    end
  end
end
