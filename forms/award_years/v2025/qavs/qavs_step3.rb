class AwardYears::V2025::QaeForms
  class << self
    def qavs_step3
      @qavs_step3 ||= proc do
        notice %(
          <p class=govuk-body>Please note your answers are being saved automatically in the background.</p>
        )

        header :supporter_letters_list_context, "" do
          context %(
            <p class='govuk-body'>Letters of support are an essential part of your nomination, as they help to clarify and explain the impact of the nominated group's work in the local community. You will need to provide 2 letters of support alongside your nomination.</p>
            <p class='govuk-body'>For more information on what letters can cover, please see the <a href="https://kavs.dcms.gov.uk/make-a-nomination/letters-of-support/" target="_blank">Letters of Support page</a> on our website.</p>
            <p class='govuk-body'><strong>Key criteria:</strong></p>
            <ol class='govuk-list govuk-list--number'>
              <li>Letters must be written by individuals who are familiar with the group's work, for example: a beneficiary, local resident or member of a partner charity.</li>
              <li>Letters must not be written by a volunteer, employee, trustee, or anyone involved in the running of the group.</li>
              <li>Letters written by the nominator will be ineligible.</li>
              <li>Each letter should be no more than 500 words.</li>
              <li>Only 2 letters of support can be submitted.</li>
            </ol>
          )
          pdf_context_with_header_blocks [
            [:normal, %(Letters of support are an essential part of your nomination, as they help to clarify and explain the impact of the nominated group's work in the local community. You will need to provide 2 letters of support alongside your nomination.)],
            [:normal, %(For more information on what letters can cover, please see the <link href="https://kavs.dcms.gov.uk/make-a-nomination/letters-of-support/" target="_blank">Letters of Support page</link> on our website.)],
            [:bold, %(Key criteria:)],
            [:normal, %(
              1. Letters must be written by individuals who are familiar with the group's work, for example: a beneficiary, local resident or member of a partner charity.
              2. Letters must not be written by a volunteer, employee, trustee, or anyone involved in the running of the group.
              3. Letters written by the nominator will be ineligible.
              4. Each letter should be no more than 500 words.
              5. Only 2 letters of support can be submitted.
            )],
          ]
        end

        supporters :supporter_letters_list, "" do
          ref "C 1"
          classes "question-support-uploads"
          limit 2
          default 2
        end

        confirm :independent_individual, "" do
          required
          text -> do
            %(
              I can confirm that these letters were written by individuals independent of the group.
            )
          end
        end

        confirm :not_nominator, "" do
          required
          text -> do
            %(
              I can confirm that these letters were not written by the nominator.
            )
          end
        end
      end
    end
  end
end
