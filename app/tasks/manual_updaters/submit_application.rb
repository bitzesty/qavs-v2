#
# Manual Submission of FormAnswer
#
# Use:
#
# ::ManualUpdaters::SubmitApplication.new(form_answer).run!
#

module ManualUpdaters
  class SubmitApplication

    attr_accessor :form_answer

    def initialize(form_answer)
      @form_answer = form_answer
    end

    def run!
      # STEP 1: Set submitted fields
      #
      form_answer.update_column(:submitted, true)
      form_answer.update_column(:submitted_at, Time.current)

      # STEP 2: Trigger state machine
      #
      form_answer.state_machine.submit(form_answer.user)

      # STEP 3: Notify user about successful submission
      #
      FormAnswerUserSubmissionService.new(form_answer).perform

      # STEP 4: Generate hard copy PDF file
      #
      HardCopyPdfGenerators::FormDataWorker.perform_async(form_answer.id, true)

      p ""
      p "[MANUAL SUBMISSION | SUCCESS] DONE! Check it at https://www.queens-awards-enterprise.service.gov.uk/admin/form_answers/#{form_answer.id}"
      p ""
    end
  end
end
