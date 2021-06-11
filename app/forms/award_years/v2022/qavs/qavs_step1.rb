# coding: utf-8
class AwardYears::V2022::QAEForms
  class << self
    def qavs_step1
      @qavs_step1 ||= proc do
        header :contact_details, "" do
          context %(
            <p><strong>Before nominating, please check that the group meets the eligibility criteria described here and fits the profile described.</strong></p>
            <p>You can view the questions in advance by downloading a copy of the form: Download Offline Form for Reference. This is only for reference. The form must be completed online.</p>
          )
        end

        text :company_name, "Name of group" do
          sub_ref "A 1"
          required
          context %(
            <p>It is important that the name is accurate and spelt correctly, as this will appear on the Award certificate if your nomination succeeds. You do not need to add a charity number.</p>
          )
          style "large"
        end
      end
    end
  end
end
