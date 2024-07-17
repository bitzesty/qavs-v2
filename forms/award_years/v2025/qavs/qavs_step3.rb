class AwardYears::V2025::QaeForms
  class << self
    def qavs_step3
      @qavs_step3 ||= proc do
        notice %(
          <p class=govuk-body>Please note your answers are being saved automatically in the background.</p>
        )

        supporters :supporter_letters_list, "" do
          ref "C 1"
          context %(
            <p class='govuk-body'>Letters of support are an essential part of your nomination, as they help to clarify and explain the impact of the nominated group’s work in the local community. You will need to provide 2 letters of support alongside your nomination.</p>
            <p class='govuk-body'>For more information on what letters can cover, please see the <a href="https://kavs.dcms.gov.uk/make-a-nomination/letters-of-support/" target="_blank">Letters of Support page</a> on our website.</p>
            <p class='govuk-body'>Key criteria:</p>
            <ol class='govuk-list govuk-list--number'>
              <li>letters must be written by individuals who are familiar with the group’s work, for example: a beneficiary, local resident or member of a partner charity</li>
              <li>letters must not be written by a volunteer, employee, trustee, or anyone involved in the running of the group</li>
              <li>letters written by the nominator will be ineligible</li>
              <li>each letter should be no more than 500 words</li>
              <li>only 2 letters of support can be submitted</li>
            </ol>
            <p class='govuk-body'>For each letter uploaded below, please note the letter writer’s relationship to the group, for example: a beneficiary of the group, local resident or member of a partner charity.</p>
            <p class='govuk-body'><strong>Once uploaded, all files are saved automatically. If you make a mistake and upload the wrong letter, please use the same button to upload the correct file as it will automatically replace the previous version.</strong></p>
          )
          classes "question-support-uploads"
          limit 2
          default 2
        end
      end
    end
  end
end
