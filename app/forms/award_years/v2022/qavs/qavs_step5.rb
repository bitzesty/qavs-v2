# -*- coding: utf-8 -*-
class AwardYears::V2022::QAEForms
  class << self
    def qavs_step5
      @qavs_step5 ||= proc do
        header :local_assessment_general_header, "General" do
          ref "E 1"
        end

        text :nomination_local_assessment_form_nominee_name, "Group name" do
          sub_ref "E 1.1"
          classes "sub-question"
          form_hint "Please check that the name given by the nominator is correct."
          required
          default_value :nominee_name
          style "large"
        end

        textarea :nomination_local_assessment_form_assessor_details, "Assessor's name and contact details" do
          sub_ref "E 1.2"
          classes "sub-question"
          required
        end

        textarea :l_citation_summary, "Citation summary" do
          sub_ref "E 2"
          classes "sub-question"
          context %(
            <p>
              Please discuss and provide a <strong>short summary of the group's work in one sentence that could be used for their certificate</strong> if they eventually receive a QAVS. The format should be similar to the examples below:
            </p>
            <p><em>"Providing advice and practical help to women at risk of domestic abuse."</em></p>
            <p><em>"Transforming derelict land into a vibrant community park."</em></p>
            <p><em>"Providing a valuable befriending service to local elderly people."</em></p>
          )
          required
          words_max 15
        end

        header :local_assessment_group_work_header, "Work of the group" do
          ref "E 3"
        end

        textarea :nomination_local_assessment_form_provided_services, "Please describe the range of services and activities provided by the group" do
          sub_ref "E 3.1"
          classes "sub-question"
          context %(
            <p>Please note, if this is a project or branch of a larger organisation, make sure this refers to the work of the project rather than the larger organisation.</p>
          )
          form_hint "Recommended words: 100"
          required
          rows 2
        end

        textarea :nomination_local_assessment_form_evidence_of_need, "What evidence is there of the need for the group's work?" do
          sub_ref "E 3.2"
          classes "sub-question"
          context %(
            <p>For example, gaps in local provision, lack of similar facilities</p>
          )
          required
        end

        textarea :nomination_local_assessment_form_benefits_made, "What difference does the group make in meeting the need described above?" do
          sub_ref "E 3.3"
          classes "sub-question"
          context %(
            <p>
              <strong>Please include direct benefits, but also any indirect benefits, </strong>such as preserving heritage or environment, promoting community cohesion among volunteers themselves or contributing to crime reduction. <strong>Please ask the group for evidence to support this</strong> (for example, number of people helped, visitor numbers) and provide details below.
            </p>
          )
        end

        textarea :nomination_local_assessment_form_makes_their_work_distinctive, "If they are a branch of a wider organisation, in what way have they made their work distinctive from that of other groups?" do
          sub_ref "E 3.4"
          classes "sub-question"
        end

        textarea :nomination_local_assessment_form_group_operation_timespan, "Does the group operate all year round, or just at certain times of the year (for example, if it is a festival)?" do
          sub_ref "E 3.5"
          classes "sub-question"
          required
        end

        textarea :nomination_local_assessment_form_local_challenges, "Please describe the area that the group serves and any challenges such as deprivation, rural isolation, lack of community, unequal opportunities." do
          sub_ref "E 3.6"
          classes "sub-question"
          required
        end

        textarea :nomination_local_assessment_form_affected_by_covid19, "How has the group's operation been affected by the Covid-19 pandemic?" do
          sub_ref "E 3.7"
          classes "sub-question"
          context %(
            <p>Please describe in detail if necessary.</p>
          )
          required
        end

        textarea :nomination_local_assessment_form_offered_services_during_pandemic, "During the pandemic has it been able to offer any additional or different services to the community?" do
          sub_ref "E 3.8"
          classes "sub-question"
          context %(
            <p>Please describe in detail.</p>
          )
          required
        end

        textarea :nomination_local_assessment_form_impact_during_pandemic, "What is the impact of this additional support during Covid-19" do
          sub_ref "E 3.9"
          classes "sub-question"
          context %(
            <p>For example, how has it helped, how many people have been supported, creation of beneficial partnerships etc?</p>
          )
          required
        end

        options :nomination_local_assessment_form_beneficiaries_based_abroad, "Are the group's beneficiaries based abroad or in other parts of the UK?" do
          sub_ref "E 3.10"
          classes "sub-question"
          yes_no
          required
        end

        options :nomination_local_assessment_form_group_based_locally, "If its beneficiaries live elsewhere, is the group itself based entirely locally?" do
          sub_ref "E 3.11"
          classes "sub-question"
          yes_no
          required
        end

        textarea :nomination_local_assessment_form_how_benefits_local_and_abroad, "In what ways does the group's existence benefit the local community as well as people elsewhere?" do
          sub_ref "E 3.12"
          classes "sub-question"
          required
        end

        header :local_assessments_volunteers_header, "Role and Status of Volunteers" do
          ref "E 4"
        end

        number :local_assessment_form_volunteers_number, "Number of volunteers" do
          sub_ref "E 4.1"
          classes "sub-question"
          style "tiny"
          required
        end

        number :local_assessment_form_paid_staff_number, "Number of full time paid staff" do
          sub_ref "E 4.2"
          classes "sub-question"
          style "tiny"
          required
        end

        options :nomination_local_assessment_form_volunteers_right_of_residence, "Do at least half the volunteers have the right of residence in the UK?" do
          sub_ref "E 4.3"
          classes "sub-question"
          yes_no
          required
        end

        textarea :nomination_local_assessment_form_volunteer_roles, "What roles do the volunteers cover and what does this involve?" do
          sub_ref "E 4.4"
          classes "sub-question"
          required
        end

        textarea :nomination_local_assessment_form_staff_roles, "What roles are covered by paid staff?" do
          sub_ref "E 4.5"
          classes "sub-question"
          required
        end

        textarea :nomination_local_assessment_form_volunteer_work_volume, "Please give an idea of the volume of work put in by volunteers" do
          sub_ref "E 4.6"
          classes "sub-question"
          context %(
            <p>Ask the group for metrics if possible, for example, 'x' number of volunteering hours are provided by 'y' volunteers each week; or the number of volunteers stated as full time equivalents (FTEs).</p>
          )
          required
        end

        textarea :nomination_local_assessment_form_aspects_relying_on_volunteer_input, "Which aspects of the group's work rely on volunteers' input?" do
          sub_ref "E 4.7"
          classes "sub-question"
          required
        end

        textarea :nomination_local_assessment_form_volunteer_representation_in_leadership_roles, "How are volunteers represented in key leadership roles? In what ways are volunteers leading, setting direction and acting as an inspiration to the rest of the group?" do
          sub_ref "E 4.8"
          classes "sub-question"
          context %(
            <p>We look for groups that are volunteer-led, with volunteers having a key input in decision making at all levels.</p>
          )
          required
        end

        textarea :nomination_local_assessment_form_evidence_of_ownership, "What evidence is there that the other volunteers can feed in their thoughts and ideas to the leadership through a regular forum or reference group? Does it feel like their own project, or are they just following instructions from paid staff?" do
          sub_ref "E 4.9"
          classes "sub-question"
          required
        end

        textarea :nomination_local_assessment_form_election_procedures, "Are there procedures for electing and refreshing the governing body?" do
          sub_ref "E 4.10"
          classes "sub-question"
          required
        end

        header :local_assessment_group_organisation_evidence_header, "Evidence of a well-run organisation" do
          ref "E 5"
          context %(
            <p>Before your visit, it is helpful to check how the group is set up (for example, unconstituted group, registered charity, community interest company etc), as the statutory requirements and published information about the group will be different in each case.</p>
            <p>The QAVS guidance for Lieutenancies provides ideas about key things to check and how to do this.</p>
          )
        end

        textarea :nomination_local_assessment_form_wider_affiliations, "Is the group affiliated to a wider group, for example, as a branch, member or partner? If so, please describe the relationship and the degree of control." do
          sub_ref "E 5.1"
          classes "sub-question"
          required
        end

        textarea :nomination_local_assessment_form_funds_source, "Where does the group get its funds from?" do
          sub_ref "E 5.2"
          classes "sub-question"
          required
        end

        textarea :nomination_local_assessment_form_financial_stability_concerns, "Are there any concerns about their financial stability?" do
          sub_ref "E 5.3"
          classes "sub-question"
          required
        end

        textarea :nomination_local_assessment_form_safeguarding_procedures, "Does the group have safeguarding procedures to ensure that children and vulnerable adults are well protected? What are they?" do
          sub_ref "E 5.4"
          classes "sub-question"
          context %(
            <p>This may include criminal record checks or having a policy on child protection and insurance indemnity."
          )
          required
        end

        textarea :nomination_local_assessment_form_adequate_insurance, "Does the group have adequate insurance to cover volunteers and members of the public with whom they interact?" do
          sub_ref "E 5.5"
          classes "sub-question"
          context %(
            <p>For example, public liability insurance or employee liability insurance?"
          )
          required
        end

        textarea :nomination_local_assessment_form_relevant_accreditions, "If relevant to the services delivered, has the group been successfully accredited by a professional body or regulator, for example, Ofsted, Care Quality Commission, HSE?" do
          sub_ref "E 5.6"
          classes "sub-question"
          required
        end

        textarea :nomination_local_assessment_form_quality_mark, "Has the group achieved any quality mark?" do
          sub_ref "E 5.7"
          classes "sub-question"
          context %(
            <p>For example, from a national sports body or a national umbrella organisation?</p>
          )
          required
        end

        textarea :nomination_local_assessment_form_other_recognition, "Has the group achieved any other recognition or gained any awards either nationally or locally?" do
          sub_ref "E 5.8"
          classes "sub-question"
          required
        end

        textarea :nomination_local_assessment_form_involvement_from_local_bodies, "During your assessment please check to see if any local bodies such as the local authority, police, health, faith or other community organisations have any involvement or support in the activities of the group." do
          sub_ref "E 5.9"
          classes "sub-question"
          context %(
            <p>If so please check their views and include your findings below.</p>
          )
          required
        end

        textarea :nomination_local_assessment_form_adverse_information, "As far as you are aware, is there any adverse information that might affect the reputation of the group or its volunteers? Are they involved in any disputes or other complaint procedures? Is there any negative publicity about them?" do
          sub_ref "E 5.10"
          classes "sub-question"
          required
        end

        header :local_assessment_inclusivity_header, "Inclusivity" do
          ref "E 6"
        end

        textarea :nomination_local_assessment_form_volunteer_recruitment_procedures, "How are volunteers recruited?" do
          sub_ref "E 6.1"
          classes "sub-question"
          required
        end

        textarea :nomination_local_assessment_form_volunteer_inclusivity_plans, "Does the group actively plan to encourage a wide range of people to volunteer (ie: from a range of ages, backgrounds, ethnicities and abilities)?" do
          sub_ref "E 6.2"
          classes "sub-question"
          context %(
            <p>Examples might include placing leaflets in social centres, libraries, welcoming messages on social media, website, providing training opportunities for unemployed volunteers.</p>
          )
          required
        end

        textarea :nomination_local_assessment_form_beneficiary_inclusivity_measures, "Does the group reach out to potential beneficiaries that might face barriers to accessing the group's services?" do
          sub_ref "E 6.3"
          classes "sub-question"
          context %(
            <p>For example, people with mental health conditions, disabled people, lonely or isolated, older people, unemployed. Please describe the measures used.</p>
          )
          required
        end

        textarea :nomination_local_assessment_form_services_accessibility, "Does the group take any practical steps to make the group's services accessible?" do
          sub_ref "E 6.4"
          classes "sub-question"
          context %(
            <p>For example, physical access to buildings, adjusting opening hours, means of contact and providing materials in a second language or alternative format.</p>
          )
          required
        end

        header :local_assessment_exceptional_qualities_header, "Exceptional qualities" do
          ref "E 7"
        end

        textarea :nomination_local_assessment_form_outstanding_features, "Which, if any, of the features of the group and its volunteers described above would you see as 'excellent'?" do
          sub_ref "E 7.1"
          classes "sub-question"
          required
        end

        textarea :nomination_local_assessment_form_exceptional_features, "Are any of these exceptional, meaning likely to be among the best in the UK?" do
          sub_ref "E 7.2"
          classes "sub-question"
          required
        end

        text :nomination_local_assessment_form_member_worthy_of_honour, "Does any member of the group stand out as being worthy of an individual honour?" do
          sub_ref "E 7.3"
          classes "sub-question"
          context %(
            <p>Please give their name</p>
          )
          required
        end

        header :local_assessment_lord_lieutenant_citation_header, "Lord Lieutenant Citation" do
          ref "E 8"

        end

        textarea :nomination_local_assessment_form_citation_full, "Lord Lieutenant Citation" do
          sub_ref "E 8"
          classes "sub-question"
          required
          words_max 600

          context %(
            <p>
              The purpose of the Lord-Lieutenant's citation is to summarise the local panel's opinion about the nominated group and to explain the decision to recommend or not recommend it. If the decision is to recommend, then these opinions will be very helpful to the Awarding Committee when making their judgements. The main guidance for Lieutenancies circulated each September provides more advice about drafting the citation, but you might want to bear in the points below when recommending a group to the national assessors:
            </p>
            <ul>
              <li>The citation does not need to repeat the detail provided in the nomination and local assessment report, since the national assessors will have studied this material carefully as well.</li>
              <li>Instead, the citation should try to capture what is exceptional about this particular group. For instance, the impact it has made on local people (particularly if the local context is challenging); the ways in which its work or approach is distinctive or different from other groups doing similar things; anything outstanding about the way the group is run; any exemplary qualities in the volunteers themselves.</li>
              <li>The citation should be around 400-600 words. It should not be longer than that, but don't make it too short either as this is an important opportunity to 'bring the group to life' for the national assessors.</li>
            </ul>
          )
          pdf_context %(
            The purpose of the Lord-Lieutenant's citation is to summarise the local panel's opinion about the nominated group and to explain the decision to recommend or not recommend it. If the decision is to recommend, then these opinions will be very helpful to the Awarding Committee when making their judgements. The main guidance for Lieutenancies circulated each September provides more advice about drafting the citation, but you might want to bear in the points below when recommending a group to the national assessors:

            \u2022 The citation does not need to repeat the detail provided in the nomination and local assessment report, since the national assessors will have studied this material carefully as well.

            \u2022 Instead, the citation should try to capture what is exceptional about this particular group. For instance, the impact it has made on local people (particularly if the local context is challenging); the ways in which its work or approach is distinctive or different from other groups doing similar things; anything outstanding about the way the group is run; any exemplary qualities in the volunteers themselves.

            \u2022 The citation should be around 400-600 words. It should not be longer than that, but don't make it too short either as this is an important opportunity to 'bring the group to life' for the national assessors.
          )

          rows 3
        end

        submit "Submit assessment" do
          notice %(
            <p>
              If you have answered all the questions, you can submit your assessment now. You will be able to edit it any time before [LIEUTENANT_SUBMISSION_ENDS_TIME].
            </p>
            <p>
              If you are not ready to submit yet, you can save your assessment and come back later.
            </p>
          )
        end
      end
    end
  end
end
