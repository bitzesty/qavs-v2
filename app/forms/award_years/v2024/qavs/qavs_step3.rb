class AwardYears::V2024::QAEForms
  class << self
    def qavs_step3
      @qavs_step3 ||= proc do
        notice %(
          <p class=govuk-body>Please note your answers are being saved automatically in the background.</p>
        )

        supporters :supporter_letters_list, "" do
          ref "C 1"
          context %(
            <p class='govuk-hint'><a href="https://kavs.dcms.gov.uk/make-a-nomination/nominate/">Before you start, please refer to our full guidance for letters of support as outlined on our website.</a></p>
            <p class='govuk-hint'>Please obtain two different letters that endorse the nominated group's contribution from people who are familiar with its work.</p>
            <p class='govuk-hint'>
              Supporters must not be volunteers or paid workers in the group. Each letter should be no more than 500 words. The letters should be about the whole group, rather than just one volunteer and should help to show how its work is outstanding.
            </p>
            <p class='govuk-hint'>Please list below the names of the supporters and their relationship (if any) to the group.</p>
          )
          hint "What are the allowed file formats?", %(
            <p class='govuk-hint'>
              Letter of support must be no larger than 5 MB.
            </p>
            <p class='govuk-hint'>
              They can be:
              <br>
              Images in jpg, jpeg and png formats;
              <br>
              Files in doc, docx, odt, pdf and txt formats.
          )
          classes "question-support-uploads"
          limit 2
          default 1
        end
      end
    end
  end
end
