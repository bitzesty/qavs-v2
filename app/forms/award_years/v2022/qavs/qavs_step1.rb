# coding: utf-8
class AwardYears::V2022::QAEForms
  class << self
    def qavs_step1
      @qavs_step1 ||= proc do
        notice %(
          <p class=govuk-body>Please note your answers are being saved automatically in the background.</p>
        )

        header :nominee_details_header, "Group details" do
          ref "A 1"
        end

        text :nominee_name, "Name of group" do
          sub_ref "A 1.1"
          required
          form_hint "It is important that the name is accurate and spelt correctly, as this will appear on the Award certificate if your nomination succeeds. You do not need to add a charity number."
          style "large"
        end

        dropdown :nominee_activity, "Please select the group's main area of activity" do
          sub_ref "A 1.2"
          required
          option "", ""
          nominee_activities
        end

        dropdown :secondary_activity, "Please select the group's secondary area of activity (optional)" do
          sub_ref "A 1.3"
          option "", ""
          nominee_activities
        end

        address :nominee_address, "Address of group" do
          sub_ref "A 1.4"
          required
          sub_fields([
            { building: "Building" },
            { street: "Street" },
            { city: "Town or city" },
            { county: "County" },
            { postcode: "Postcode" }
          ])
        end

        ceremonial_county :nominee_ceremonial_county, "Lieutenancy county (if known)" do
          sub_ref "A 1.5"
          option "", ""
          counties
        end

        text :nominee_phone, "Telephone number" do
          sub_ref "A 1.6"
          style "small"
          type "tel"
        end

        text :nominee_website, "Website" do
          sub_ref "A 1.7"
          style "large"
        end

        textarea :social_media, "Social media" do
          sub_ref "A 1.8"
          form_hint "Social media accounts if known"
          words_max 100
          rows 2
        end

        header :nominee_leader_header, "About the group leader or main contact in the group" do
          ref "A 2"
          context %(
            <p class='govuk-hint'>This is the person the County Assessment Panel will contact to ask any questions or arrange a visit.</p>
          )
        end

        text :nominee_leader_name, "Name of the group leader or main contact in the group" do
          sub_ref "A 2.1"
          required
          style "small"
        end

        text :nominee_leader_position, "Position held in the group" do
          sub_ref "A 2.2"
          required
          style "large"
        end

        address :nominee_leader_address, "Address of main contact" do
          sub_ref "A 2.3"
          required
          sub_fields([
            { building: "Building" },
            { street: "Street" },
            { city: "Town or city" },
            { county: "County" },
            { postcode: "Postcode" }
          ])
        end

        text :nominee_leader_email, "Email" do
          sub_ref "A 2.4"
          required
          type "email"
          style "large"
        end

        text :nominee_leader_telephone, "Telephone" do
          sub_ref "A 2.5"
          style "small"
          type "tel"
        end
      end
    end
  end
end
