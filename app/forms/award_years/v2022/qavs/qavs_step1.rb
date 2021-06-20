# coding: utf-8
class AwardYears::V2022::QAEForms
  class << self
    def qavs_step1
      @qavs_step1 ||= proc do
        header :nominee_details_header, "Group Details" do
          ref "A 1"
          context %(
            <p><strong>Before nominating, please check that the group meets the eligibility criteria described here and fits the profile described.</strong></p>
            <p>You can view the questions in advance by downloading a copy of the form: Download Offline Form for Reference. This is only for reference. The form must be completed online.</p>
          )
        end

        text :nominee_name, "Name of group" do
          sub_ref "A 1.1"
          required
          context %(
            <p>It is important that the name is accurate and spelt correctly, as this will appear on the Award certificate if your nomination succeeds. You do not need to add a charity number.</p>
          )
          style "large"
        end

        address :nominee_address, "Contact details for the group" do
          sub_ref "A 1.2"
          required
        end

        text :nominee_phone, "Telephone number" do
          sub_ref "A 1.3"
          style "small"
        end

        text :nominee_website, "Website" do
          sub_ref "A 1.4"
          style "large"
        end

        textarea :social_media, "Social media" do
          sub_ref "A 1.5"
          form_hint "Social media accounts if known"
          words_max 100
          rows 2
        end

        header :nominee_contact_header, "About the group leader or main contact in the group" do
          ref "A 2"
          context %(
            <p>This is the person the County Assessment Panel will contact to ask any questions or arrange a visit.</p>
          )
        end

        text :nominee_contact, "Name of the group leader or main contact in the group" do
          sub_ref "A 2.1"
          required
          style "small"
        end

        text :nominee_position, "Position held in the group" do
          sub_ref "A 2.2"
          required
          style "large"
        end
      end
    end
  end
end
