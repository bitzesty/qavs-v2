# -*- coding: utf-8 -*-
class AwardYears::V2022::QAEForms
  class << self
    def qavs_step4
      @qavs_step4 ||= proc do
        header :head_of_business_header, "Head of your organisation" do
          ref "D 1"
        end

        text :head_of_business_title, "Title" do
          required
          classes "sub-question"
          style "tiny"
        end

        head_of_business :head_of_business, "" do
          sub_fields([
            { first_name: "First name" },
            { last_name: "Last name" },
            { honours: "Personal Honours" }
          ])
        end

        text :head_job_title, "Job title / role in the organisation" do
          classes "sub-question"
          required
          form_hint %(
            e.g. CEO, Managing Director, Founder
          )
        end

        text :head_email, "Email address" do
          classes "sub-question"
          style "large"
          required
        end

        confirm :entry_confirmation, "Confirmation of nomination" do
          ref "D 4"
          required
          text -> do
            %(
              I confirm that, to the best of my knowledge and belief, the information in this form is true and correct. I have discussed the nomination with the group. It is happy to be nominated and is aware that it will be contacted by representatives of the Award and asked for further information, as part of the assessment process.
            )
          end
        end

        submit "Submit application" do
          notice %(
            <p>
              If you have answered all the questions, you can submit your application now. You will be able to edit it any time before [SUBMISSION_ENDS_TIME].
            </p>
            <p>
              If you are not ready to submit yet, you can save your application and come back later.
            </p>
          )
        end
      end
    end
  end
end
