# -*- coding: utf-8 -*-
class AwardYears::V2022::QAEForms
  class << self
    def qavs_step4
      @qavs_step4 ||= proc do
        header :nominator_details_header, "Details of person making the nomination" do
          ref "D 1"
        end

        text :nominator_title, "Title" do
          sub_ref "D 1.1"
          required
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

        text :nominator_telephone, "Telephone" do
          sub_ref "D 1.4"
          style "small"
        end

        text :nominator_mobile, "Mobile" do
          sub_ref "D 1.5"
          style "small"
        end

        text :nominator_email, "Email address" do
          sub_ref "D 1.6"
          style "large"
          required
        end

        confirm :not_volunteer, "" do
          sub_ref "D 2"
          required
          text -> do
            %(
              I am neither a volunteer nor a paid member of the group.
            )
          end
        end

        confirm :understood_privacy_notice, "" do
          sub_ref "D 3"
          required
          text -> do
            %(
              I have read and understood the contents of the <a href="https://qavs.dcms.gov.uk/privacy-policy/">Privacy Notice
            )
          end
        end

        confirm :group_leader_aware, "" do
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
              I confirm that, to the best of my knowledge and belief, the information in this form is true and correct. I have discussed the nomination with the group. It is happy to be nominated and is aware that it will be contacted by representatives of the Award and asked for further information, as part of the assessment process.
            )
          end
        end

        submit "Submit nomination" do
          notice %(
            <p class='govuk-hint'>
              If you have answered all the questions, you can submit your nomination now. You will be able to edit it any time before [SUBMISSION_ENDS_TIME].
            </p>
            <p class='govuk-hint'>
              If you are not ready to submit yet, you can save your nomination and come back later.
            </p>
          )
        end
      end
    end
  end
end
