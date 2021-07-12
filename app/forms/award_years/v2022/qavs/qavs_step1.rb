# coding: utf-8
class AwardYears::V2022::QAEForms
  class << self
    def qavs_step1
      @qavs_step1 ||= proc do
        header :nominee_details_header, "Group Details" do
          ref "A 1"
        end

        text :nominee_name, "Name of group" do
          sub_ref "A 1.1"
          classes "sub-question"
          required
          form_hint "It is important that the name is accurate and spelt correctly, as this will appear on the Award certificate if your nomination succeeds. You do not need to add a charity number."
          style "large"
        end

        dropdown :nominee_activity, "Please select the group's main area of activity" do
          sub_ref "A 1.2"
          classes "sub-question"
          required
          option "", "Please select"
          option "ART", "Arts"
          option "EDU", "Education"
          option "EME", "Emergency response"
          option "ENV", "Environment & regeneration"
          option "HEA", "Health"
          option "HER", "Heritage"
          option "OTH", "Other"
          option "PLY", "Playscheme/youth"
          option "SUP", "Self help/support group"
          option "SOC", "Social centre/community"
          option "SPS", "Social preventative scheme"
          option "SPO", "Sports"
        end

        address :nominee_address, "Address of group" do
          sub_ref "A 1.3"
          classes "sub-question"
          required
          sub_fields([
            { building: "Building" },
            { street: "Street" },
            { city: "Town or city" },
            { county: "County" },
            { postcode: "Postcode" }
          ])
        end

        text :nominee_phone, "Telephone number" do
          sub_ref "A 1.4"
          classes "sub-question"
          style "small"
        end

        text :nominee_website, "Website" do
          sub_ref "A 1.5"
          classes "sub-question"
          style "large"
        end

        textarea :social_media, "Social media" do
          sub_ref "A 1.6"
          classes "sub-question"
          form_hint "Social media accounts if known"
          words_max 100
          rows 2
        end

        header :nominee_leader_header, "About the group leader or main contact in the group" do
          ref "A 2"
          context %(
            <p>This is the person the County Assessment Panel will contact to ask any questions or arrange a visit.</p>
          )
        end

        text :nominee_leader_name, "Name of the group leader or main contact in the group" do
          sub_ref "A 2.1"
          classes "sub-question"
          required
          style "small"
        end

        text :nominee_leader_position, "Position held in the group" do
          sub_ref "A 2.2"
          classes "sub-question"
          required
          style "large"
        end

        address :nominee_leader_address, "Address of main contact" do
          sub_ref "A 2.3"
          classes "sub-question"
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
          classes "sub-question"
          required
          style "large"
        end

        text :nominee_leader_telephone, "Telephone" do
          sub_ref "A 2.5"
          classes "sub-question"
          required
          style "small"
        end
      end
    end
  end
end
