# -*- coding: utf-8 -*-
class AwardYears::V2022::QAEForms
  class << self
    def qavs_step5
      @qavs_step5 ||= proc do
        header :lieutenants_general_header, "Local Assessment Form" do
          ref "E 1"
        end

        # header :lieutenants_wotg_header, "Work of the Group" do
        #   ref "E 2"
        # end

        textarea :l_citation_summary, "Citation summary" do
          sub_ref "E 1.2"
          classes "sub-question"
          required
        end


#         textarea :nomination_local_assessment_form_provided_services, "Please describe the range of services and activities provided by the group" do
#         end

#         textarea :nomination_local_assessment_form_evidence_of_need, "What evidence is there of the need for the group's work?" do
#         end

#         textarea :nomination_local_assessment_form_benefits_made, "What difference does the group make in meeting the need described above?" do
#         end

#         textarea :nomination_local_assessment_form_makes_their_work_distinctive, "If they are a branch of a wider organisation, in what way have they made their work distinctive from that of other groups?" do

#         textarea :nomination_local_assessment_form_group_operation_timespan, "Does the group operate all year round, or just at certain times of the year (e.g. a festival)?" do

#         textarea :nomination_local_assessment_form_local_challenges
# "Please describe the area that the group serves and any challenges such as deprivation, rural isolation, lack of community, unequal opportunities." do
#        textarea :nomination_local_assessment_form_affected_by_covid19
# "How has the group's operation been affected by the Covid-19 pandemic?" do

# textarea :nomination_local_assessment_form_offered_services_during_pandemic
# "During the pandemic has it been able to offer any additional or different services to the community?" do

# textarea :nomination_local_assessment_form_impact_during_pandemic
# "What is the impact of this additional support during Covid-19" do


# options :nomination_local_assessment_form_beneficiaries_based_abroad
# "Are the group's beneficiaries based abroad or in other parts of the UK?" do
# yes_no


# options :nomination_local_assessment_form_group_based_locally
# "If its beneficiaries live elsewhere, is the group itself based entirely locally?" do
# yes_no

# textarea :nomination_local_assessment_form_how_benefits_local_and_abroad
# "In what ways does its existence benefit the local community as well as people elsewhere?" do

        submit "Submit application" do
          notice %(
            <p>
              If you have answered all the questions, you can submit your application now. You will be able to edit it any time before [LIEUTENANT_SUBMISSION_ENDS_TIME].
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
