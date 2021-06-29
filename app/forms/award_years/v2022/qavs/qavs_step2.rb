# -*- coding: utf-8 -*-
class AwardYears::V2022::QAEForms
  class << self
    def qavs_step2
      @qavs_step2 ||= proc do
        header :recommendation, "" do
          context %(
            <h3>About this section</h3>
            <p>
            In this section, please explain how your nominated group has made a significant contribution in its area of activity. 
            We are looking for groups that have given excellent service to their beneficiaries and communities; 
            have delivered their service in innovative ways, and have shown other examples of selfless voluntary service that distinguish their work. 
            <strong>Please answer each question, noting the word limits, explaining what achievements make the nominated group stand out from others.</strong>
            </p>
          )
        end

        textarea :group_activities, "Please summarise the activities of the group" do
          ref "B 1"
          classes "sub-question"
          required
          words_max 50
          rows 2
        end

        textarea :beneficiaries, "Who are the beneficiaries (the people it helps) and where do they live?" do
          ref "B 2"
          classes "sub-question"
          required
          words_max 30
          rows 2
        end

        textarea :benefits, "What are the benefits of the group's work?" do
          ref "B 3"
          classes "sub-question"
          required
          words_max 100
          rows 2
        end

        textarea :volunteers, "This Award is specifically for groups that rely on significant and committed work by volunteers. Please explain what the volunteers do and what makes this particular group of volunteers so impressive?" do
          ref "B 4"
          classes "sub-question"
          required
          words_max 200
          rows 5
        end

        checkbox_seria :how_did_you_hear_about_award, "How did you hear about the Award this year?" do
          ref "B 5"
          classes "sub-question"
          required
          context %(
            <p>Select all that apply.</p>
          )
          check_options [
            ["national_newspaper", "National newspaper"],
            ["local_newspaper", "Local newsaper"],
            ["tv_radio", "TV/radio"],
            ["internet", "Internet"],
            ["word_of_mouth", "Word of mouth"],
            ["previous_winner", "Previous winner/entrant"],
            ["charity", "Voluntary organisation/charity"],
            ["event", "Local event"],
            ["library", "Local library"],
            ["council", "Local Council"], 
            ["other", "Other"]
          ]
        end
      end
    end
  end
end