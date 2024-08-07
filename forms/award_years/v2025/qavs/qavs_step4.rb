# -*- coding: utf-8 -*-
class AwardYears::V2025::QaeForms
  class << self
    def qavs_step4
      @qavs_step4 ||= proc do
        notice %(
          <p class=govuk-body>Please note your answers are being saved automatically in the background.</p>
        )

        header :nominator_details_header, "Details of person making the nomination" do
          ref "D 1"
        end

        text :nominator_title, "Title" do
          sub_ref "D 1.1"
          style "tiny"
        end

        text :nominator_name, "Name" do
          sub_ref "D 1.2"
          required
        end

        address :nominator_address, "Address" do
          sub_ref "D 1.3"
          required
          sub_fields([
            { building: "Building" },
            { street: "Street" },
            { city: "Town or city" },
            { county: "County" },
            { postcode: "Postcode" }
          ])
        end

        text :nominator_telephone, "Telephone (optional)" do
          sub_ref "D 1.4"
          style "small"
          type "tel"
        end

        text :nominator_mobile, "Mobile (optional)" do
          sub_ref "D 1.5"
          style "small"
          type "tel"
        end

        text :nominator_email, "Email address" do
          sub_ref "D 1.6"
          style "large"
          type "email"
          required
        end

        confirm :not_volunteer, "Confirmation of relationship to the group" do
          sub_ref "D 2"
          required
          text -> do
            %(
              I am neither a volunteer, employee or trustee of the group, or in any way involved with the running of the organisation
            )
          end
        end

        confirm :understood_privacy_notice, "Confirmation of understanding of the privacy policy" do
          sub_ref "D 3"
          required
          text -> do
            %(
              I have read and understood the contents of the <a href="https://kavs.dcms.gov.uk/privacy-policy/" target="_blank">Privacy Notice</a>
            )
          end
        end

        confirm :group_leader_aware, "Confirmation of consent from supporters and group leaders" do
          sub_ref "D 4"
          required
          text -> do
            %(
              The group leader and writers of support letters are aware that their details have been included with this nomination.
            )
          end
        end

        confirm :entry_confirmation, "Confirmation of nomination" do
          sub_ref "D 5"
          required
          text -> do
            %(
              I confirm that, to the best of my knowledge and belief, the information in this form is true and correct. I have discussed the nomination with the group. It is happy to be nominated and is aware that it will be contacted by representatives of the Award and asked for further information, as part of the assessment process. I acknowledge that any false information provided may result in the withdrawal of this nomination from the Award.
            )
          end
        end

        submit "Submit nomination" do
          notice %(
            <p class='govuk-body'>
              If you have answered all the questions, you can submit your nomination now. You will be able to edit it any time before [SUBMISSION_ENDS_TIME].
            </p>
            <p class='govuk-body'>
              If you are not ready to submit yet, you can save your nomination and come back later.
            </p>
          )
        end
      end
    end
  end
end
