# coding: utf-8
class AwardYears::V2022::QAEForms
  class << self
    def qavs_step1
      @qavs_step1 ||= proc do
        header :nominee_details_header, "Group Details" do
          context %(
            <p><strong>Before nominating, please check that the group meets the eligibility criteria described here and fits the profile described.</strong></p>
            <p>You can view the questions in advance by downloading a copy of the form: Download Offline Form for Reference. This is only for reference. The form must be completed online.</p>
          )
        end

        text :nominee_name, "Name of group" do
          classes "sub-question"
          required
          form_hint "It is important that the name is accurate and spelt correctly, as this will appear on the Award certificate if your nomination succeeds. You do not need to add a charity number."
          style "large"
        end

        address :nominee_address, "" do
          classes "sub-question"
          required
        end

        text :nominee_phone, "Telephone number" do
          classes "sub-question"
          style "small"
        end

        text :nominee_website, "Website" do
          classes "sub-question"
          style "large"
        end

        textarea :social_media, "Social media" do
          classes "sub-question"
          form_hint "Social media accounts if known"
          words_max 100
          rows 2
        end

        header :nominee_leader_header, "About the group leader or main contact in the group" do
          context %(
            <p>This is the person the County Assessment Panel will contact to ask any questions or arrange a visit.</p>
          )
        end

        text :nominee_leader, "Name of the group leader or main contact in the group" do
          classes "sub-question"
          required
          style "small"
        end

        text :nominee_leader_position, "Position held in the group" do
          classes "sub-question"
          required
          style "large"
        end

        address :nominee_leader_address, "" do
          classes "sub-question"
          required
        end

        text :nominee_leader_email, "Email" do
          classes "sub-question"
          required
          style "large"
        end

        text :nominee_leader_telephone, "Telephone" do
          classes "sub-question"
          required
          style "small"
        end
      end
    end
  end
end
