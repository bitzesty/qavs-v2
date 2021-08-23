# -*- coding: utf-8 -*-
class AwardYears::V2022::QAEForms
  class << self
    def qavs_step5
      @qavs_step5 ||= proc do
        header :local_assessment_general_header, "General information" do
          context %(
            <p class=govuk-body>Thank you for conducting the local assessment for QAVS. Before starting the assessment, please read the QAVS local assessment guide that you can download from your dashboard page. The guide provides helpful tips on approaching the assessment.<p>
          )
        end

        assessor_details :assessor_details, 'Assessor details' do
          sub_ref "E1.1"
          required
        end

        text :nomination_local_assessment_form_nominee_name, "Group name" do
          sub_ref "E 1.2"
          form_hint "Please check that the name given by the nominator is correct."
          required
          default_value :nominee_name
          style "large"
        end

        text :local_assessment_group_leader, "Name of the group leader or main contact in the group" do
          sub_ref "E 1.3"
          form_hint "Please check that the details provided by the nominator are correct."
          required
          default_value :nominee_leader_name
          style "medium"
        end

        text :local_assessment_group_leader_position, "Position held in the group by the group leader or main contact" do
          sub_ref "E 1.4"
          form_hint "Please check that the details provided by the nominator are correct."
          required
          default_value :nominee_leader_position
          style "medium"
        end

        address :local_assessment_group_address, "Address of the group leader or main contact" do
          sub_ref "E 1.5"
          form_hint "Please check that the details provided by the nominator are correct."
          required
        end

        text :local_assessment_group_leader_email, "Email of the group leader or main contact" do
          sub_ref "E 1.6"
          form_hint "Please check that the details provided by the nominator are correct."
          required
          default_value :nominee_leader_email
          style "large"
        end

        text :local_assessment_group_leader_phone, "Telephone of the group leader or main contact" do
          sub_ref "E 1.7"
          form_hint "Please check that the details provided by the nominator are correct."
          required
          default_value :nominee_leader_telephone
        end

        confirm :group_details_confirmed, "Confirm group details" do
          sub_ref "E 1.8"
          required
          text -> do
            %(
              I confirm that I have checked and, where required, amended the group name and group leader’s details.
            )
          end
        end

        header :local_assessment_key_facts_header, "Key facts" do
        end

        number :local_assessment_form_volunteers_number, "Number of volunteers" do
          sub_ref "E 2.1"
          style "tiny"
          required
        end

        number :local_assessment_form_paid_staff_number, "Number of full time paid staff" do
          sub_ref "E 2.2"
          style "tiny"
          required
        end

        number :local_assessment_form_part_time_staff_number, "Number of part time paid staff" do
          sub_ref "E 2.3"
          style "tiny"
          required
        end

        number :local_assessment_form_beneficiaires_number, "Number of beneficiaries (can be approximate)" do
          sub_ref "E 2.4"
          style "tiny"
          required
        end

        options :nomination_local_assessment_form_volunteers_right_of_residence, "Do at least half the volunteers have the right of residence in the UK?" do
          sub_ref "E 2.5"
          form_hint "This is an eligibility matter for the Honours System that needs simple confirmation with the group. If the answer is no, please get in touch with the QAVS team before continuing with the assessment."
          yes_no
          required
        end

        header :local_assessment_citation_header, "Citation" do
        end

        textarea :l_citation_summary, "Provide a short citation summarising what the group does" do
          sub_ref "E 3.1"
          context %(
            <p class='govuk-hint'>
              Please discuss with a group and provide a <strong>short summary of the group's work in one sentence that is no longer than 100 characters, including spaces</strong>. It can also include the name of the town or area.
            </p>
            <p class='govuk-hint'>The citation will be used for the group’s certificate if they eventually receive the Queen’s Award for Voluntary Service.</p>
            <p class='govuk-hint'>Please see the examples below:</p>
            <ul govuk-list>
              <li class='govuk-hint'>"Maintaining [name of park] for the benefit of the whole community."</li>
              <li class='govuk-hint'>"Providing vital support, raising aspirations and promoting community integration in [town]."</li>
              <li class='govuk-hint'>"Providing financial, social, health and education services to the local community."</li>
              <li class='govuk-hint'>"Enriching [town], with a prime focus on its railway station, for the benefit of the whole community."</li>
              <li class='govuk-hint'>"Transforming a derelict stretch of canal into a wildlife haven and a vibrant community facility."</li>
              <li class='govuk-hint'>"Fulfilling a need whilst providing a valuable village amenity and supporting the local community."</li>
              <li class='govuk-hint'>"Enabling disabled people of all ages to enjoy the therapeutic excitement of pony carriage driving."</li>
              <li class='govuk-hint'>"Promoting wellbeing and reducing loneliness and isolation in [town or area]."</li>
            </ul>
          )
          required
          words_max 100
        end

        header :local_assessment_group_work_header, "Work of the group" do
        end

        textarea :nomination_local_assessment_form_provided_services, "Describe the range of services and activities provided by the group" do
          sub_ref "E 4.1"
          context %(
            <p class='govuk-hint'>If this is a project or a branch of a larger organisation, make sure this refers to the work of the project or the branch rather than the larger organisation.</p>
          )
          form_hint "Recommended words: 100"
          required
          rows 2
        end

        textarea :nomination_local_assessment_form_evidence_of_need, "Describe what is the need for the group's work and provide evidence" do
          sub_ref "E 4.2"
          context %(
            <p class='govuk-hint'>For example, gaps in local provision, lack of similar facilities</p>
          )
          required
        end

        textarea :nomination_local_assessment_form_benefits_made, "What difference does the group make in meeting the need described above?" do
          sub_ref "E 4.3"
          context %(
            <p class='govuk-hint'>
              <strong>Please include direct benefits, but also any indirect benefits</strong>. For example, preserving heritage or environment, promoting community cohesion among volunteers, or contributing to crime reduction.
            </p>
            <p class='govuk-hint'>
              <strong>Provide evidence to support this</strong>, for example, number of people helped, visitor numbers.
            </p>
          )
          required
        end

        textarea :nomination_local_assessment_form_makes_their_work_distinctive, "If the group is a branch of a wider organisation, how has the group made its work distinctive from that of other groups in the organisation?" do
          sub_ref "E 4.4"
        end

        textarea :nomination_local_assessment_form_group_operation_timespan, "Describe whether the group operates all year round, or just at certain times of the year, for example, during a festival or during school breaks" do
          sub_ref "E 4.5"
          required
        end

        textarea :nomination_local_assessment_form_local_challenges, "Describe the local area the group serves and any challenges the area faces, such as deprivation, rural isolation, lack of community, unequal opportunities" do
          sub_ref "E 4.6"
          context %(
            <p class='govuk-hint'>Please give examples</p>
          )
          required
        end

        options :nomination_local_assessment_form_beneficiaries_based_abroad, "Are the group's beneficiaries based abroad or in other parts of the UK?" do
          sub_ref "E 4.7"
          yes_no
          required
        end

        options :nomination_local_assessment_form_group_based_locally, "If its beneficiaries live elsewhere, is the group itself based entirely locally?" do
          sub_ref "E 4.8"
          yes_no
          conditional :nomination_local_assessment_form_beneficiaries_based_abroad, "yes"
          pdf_context %(
            If the answer is ‘no’, please skip to section 5 - ‘Role and status of volunteers’.
            If the answer is ‘yes’, please answer questions E4.8 and E4.9.
          )
        end

        textarea :nomination_local_assessment_form_how_benefits_local_and_abroad, "In what ways does the group's existence benefit the local community as well as people elsewhere?" do
          sub_ref "E 4.9"
          conditional :nomination_local_assessment_form_beneficiaries_based_abroad, "yes"
        end

        header :local_assessments_volunteers_header, "Role and status of volunteers" do
        end

        textarea :nomination_local_assessment_form_volunteer_roles, "What roles do the volunteers cover, and what does this involve?" do
          sub_ref "E 5.1"
          required
        end

        textarea :nomination_local_assessment_form_staff_roles, "What roles are covered by paid staff, and what is their relationship to the volunteers, for example, supervision, support?" do
          sub_ref "E 5.2"
          required
        end

        textarea :nomination_local_assessment_form_volunteer_work_volume, "Please give an idea of the volume of work put in by volunteers" do
          sub_ref "E 5.3"
          context %(
            <p class='govuk-hint'>If possible, provide metrics, for example, ‘x’ number of volunteering hours are provided by ‘y’ volunteers each week; or the number of volunteers expressed as full time equivalents (FTEs).</p>
          )
          required
        end

        textarea :nomination_local_assessment_form_aspects_relying_on_volunteer_input, "Which aspects of the group's work rely on volunteers' input?" do
          sub_ref "E 5.4"
          required
        end

        textarea :nomination_local_assessment_form_volunteer_representation_in_leadership_roles, "How are volunteers represented in key leadership roles? In what ways are volunteers leading, setting direction and acting as an inspiration to the rest of the group?" do
          sub_ref "E 5.5"
          context %(
            <p class='govuk-hint'>We look for volunteer-led groups, with volunteers having a key input in decision making at all levels. If relevant, please state what is the split between the volunteers and paid staff in terms of leadership.</p>
          )
          required
        end

        textarea :nomination_local_assessment_form_evidence_of_ownership, "What evidence is there that all of the volunteers can contribute their thoughts and ideas to the leadership?" do
          sub_ref "E 5.6"
          context %(
            <p class='govuk-hint'>Does it feel like their own project, or are they following instructions from the leadership team (even if the leadership team is made up of volunteers)?</p>
          )
          required
        end

        textarea :nomination_local_assessment_form_election_procedures, "Are there procedures for electing and refreshing the governing body?" do
          sub_ref "E 5.7"
          required
        end

        header :local_assessment_group_organisation_evidence_header, "Evidence of a well-run organisation" do
          context %(
            <p class='govuk-hint'>Before your visit to the group, it is helpful to check how the group is set up, for example, unconstituted group, registered charity, community interest company, as the statutory requirements and published information about the group will be different in each case. The QAVS local assessment guide, which can be downloaded from your dashboard page, provides ideas about key things to check and how to do this.</p>
          )
        end

        textarea :nomination_local_assessment_form_wider_affiliations, "Is the group affiliated to a wider group, for example, as a branch, member or partner?" do
          sub_ref "E 6.1"
          context %(
            <p class='govuk-hint'>Please describe the relationship and the degree of control. For example, does the larger group control the activity of the nominated group or simply act as a source of advice or quality assurance?</p>
          )
          required
        end

        textarea :nomination_local_assessment_form_funds_source, "Where does the group get its funds from?" do
          sub_ref "E 6.2"
          required
        end

        textarea :nomination_local_assessment_form_financial_stability_concerns, "Please describe if there are any concerns about the group’s financial stability" do
          sub_ref "E 6.3"
          required
        end

        textarea :nomination_local_assessment_form_safeguarding_procedures, "Please describe what safeguarding procedures the group has to ensure that children and vulnerable adults are well protected" do
          sub_ref "E 6.4"
          context %(
            <p class='govuk-hint'>This may include criminal record checks or having a policy on child protection and insurance indemnity.</p>
          )
          required
        end

        textarea :nomination_local_assessment_form_adequate_insurance, "Does the group have adequate insurance to cover volunteers and members of the public with whom they interact?" do
          sub_ref "E 6.5"
          context %(
            <p class='govuk-hint'>This may include public liability insurance or employee liability insurance. Please specify.</p>
          )
          required
        end

        textarea :nomination_local_assessment_form_relevant_accreditions, "If relevant to the services delivered, has the group been successfully accredited by a professional body or regulator?" do
          sub_ref "E 6.6"
          context %(
            <p class='govuk-hint'>For example, Ofsted, Care Quality Commission, HSE.</p>
          )
          required
        end

        textarea :nomination_local_assessment_form_quality_mark, "Has the group achieved any quality mark?" do
          sub_ref "E 6.7"
          context %(
            <p class='govuk-hint'>For example, from a national sports body or a national umbrella organisation?</p>
          )
          required
        end

        textarea :nomination_local_assessment_form_other_recognition, "Has the group achieved any other recognition or gained any awards either nationally or locally?" do
          sub_ref "E 6.8"
          required
        end

        textarea :nomination_local_assessment_form_involvement_from_local_bodies, "Do any local bodies such as the local authority, police, health, faith or other community organisations have any involvement, or support in the activities of the group?" do
          sub_ref "E 6.9"
          context %(
            <p class='govuk-hint'>Please check with the authorities during your assessment and state their views about the group.</p>
            <p class='govuk-hint'>Please include your findings below.</p>
          )
          required
        end

        textarea :nomination_local_assessment_form_adverse_information, "As far as you are aware, is there any adverse information that might affect the reputation of the group or its volunteers?" do
          sub_ref "E 6.10"
          context %(
            <p class='govuk-hint'>For example, are they involved in any disputes or other complaint procedures, or is there any negative publicity about them?</p>
          )
          required
        end

        header :local_assessment_inclusivity_header, "Inclusivity" do
        end

        textarea :nomination_local_assessment_form_volunteer_recruitment_procedures, "How are volunteers recruited?" do
          sub_ref "E 7.1"
          required
        end

        textarea :nomination_local_assessment_form_volunteer_inclusivity_plans, "How does the group actively encourage a wide range of people to volunteer?" do
          sub_ref "E 7.2"
          context %(
            <p class='govuk-hint'>This may include encouraging people from a range of ages, backgrounds, ethnicities and abilities.  For example, they may do so by placing leaflets in social centres or libraries, posting welcoming messages on social media or their website, or providing training opportunities for unemployed volunteers.</p>
          )
          required
        end

        textarea :nomination_local_assessment_form_beneficiary_inclusivity_measures, "How does the group reach out to potential beneficiaries that might face barriers to accessing the group’s services?" do
          sub_ref "E 7.3"
          context %(
            <p class='govuk-hint'>For example, people with mental health conditions, disabled people, lonely or isolated, older people or unemployed.</p>
          )
          required
        end

        textarea :nomination_local_assessment_form_services_accessibility, "Does the group take any practical steps to make the group's services accessible?" do
          sub_ref "E 7.4"
          context %(
            <p class='govuk-hint'>For example, by improving physical access to buildings, adjusting opening hours or means of contact and providing materials in a second language or alternative format.</p>
          )
          required
        end

        header :local_assessment_exceptional_qualities_header, "Exceptional qualities" do
        end

        textarea :nomination_local_assessment_form_outstanding_features, "Which, if any, of the features of the group and its volunteers described above would you describe as excellent?" do
          sub_ref "E 8.1"
          required
        end

        textarea :nomination_local_assessment_form_exceptional_features, "Are any of these exceptional?" do
          sub_ref "E 8.2"
          context %(
            <p class='govuk-hint'>In other words, are they likely to be among the best in the UK?</p>
          )
          required
        end

        options :nomination_local_assessment_form_member_worthy_of_honour, "Would you recommend any individual for a national Honour?" do
          sub_ref "E 8.3"
          yes_no
          required
        end

        text :nomination_local_assessment_worthy_of_honour_name, "Please give their name" do
          sub_ref "E 8.4"
          style "medium"
          conditional :nomination_local_assessment_form_member_worthy_of_honour, "yes"
        end

        textarea :nomination_local_assessment_worthy_of_honur_reasons, "Please explain in one sentence why they might merit this" do
          sub_ref "E 8.5"
          context %(
            <p class='govuk-hint'>Please note, the QAVS team will pass this information onto the DCMS Honours team. They might get in touch with you in due course to ask for further details.</p>
          )
          words_max 50
          conditional :nomination_local_assessment_form_member_worthy_of_honour, "yes"
        end

        textarea :nomination_local_assessment_form_citation_full, "Lord-Lieutenant evaluation summary" do
          sub_ref "E 9"
          required
          words_max 600
          context %(
            <p class='govuk-hint'>
              The purpose of the Lord-Lieutenant's citation is to summarise the local panel's opinion about the nominated group and to explain the decision to recommend or not recommend it. If the decision is to recommend, these opinions will be beneficial to the Awarding Committee when making their judgements.
            </p>
            <p class='govuk-hint'>Please read the guidance about the citation below:</p>
            <ul class='govuk-list govuk-list--bullet govuk-list--spaced govuk-hint'>
              <li>The citation does not need to repeat the detail provided in the nomination and local assessment report, since the national assessors will have studied this material carefully.</li>
              <li>Instead, the citation should try to capture what is exceptional about this particular group.</li>
              <p>For example:</p>
                <ul class='govuk-list govuk-list--bullet govuk-hint'>
                  <li>the impact it has made on local people, particularly if the local context is challenging;</li>
                  <li>how its work or approach is distinctive or different from other groups doing similar things;</li>
                  <li>anything outstanding about the way the group is run;</li>
                  <li>any exemplary qualities in the volunteers themselves.</li>
                </ul>
              <li>The citation should be around 400-600 words. It should not be longer than that, but don't make it too short either, as this is an opportunity to bring the group to life for the national assessors.</li>
            </ul>
            <p class='govuk-hint'>You can also find more detailed information in the QAVS local assessment guide.</p>
          )
          pdf_context %(
            The purpose of the Lord-Lieutenant's citation is to summarise the local panel's opinion about the nominated group and to explain the decision to recommend or not recommend it. If the decision is to recommend, these opinions will be beneficial to the Awarding Committee when making their judgements.
            Please read the guidance about the citation below:
            \u2022 The citation does not need to repeat the detail provided in the nomination and local assessment report, since the national assessors will have studied this material carefully.
            \u2022 Instead, the citation should try to capture what is exceptional about this particular group.
            For example:
              \u25E6 the impact it has made on local people, particularly if the local context is challenging;
              \u25E6 how its work or approach is distinctive or different from other groups doing similar things;
              \u25E6 anything outstanding about the way the group is run;
              \u25E6 any exemplary qualities in the volunteers themselves.
            \u2022 The citation should be around 400-600 words. It should not be longer than that, but don't make it too short either, as this is an opportunity to bring the group to life for the national assessors.
            You can also find more detailed information in the QAVS local assessment guide.
          )
          rows 3
        end

        options :local_assessment_verdict, "Local assessment outcome" do
          sub_ref "E 10"
          classes "govuk-notification-banner govuk-notification-banner__content"
          option "recommended", "Recommended"
          option "not_recommended", "Not recommended"
          required
        end

        submit "Submit local assessment" do
          notice %(
            <p class='govuk-hint'>
              If you have answered all the questions, you can submit your assessment now. You will be able to edit it any time before [LIEUTENANT_SUBMISSION_ENDS_TIME].
            </p>
            <p class='govuk-hint'>
              If you are not ready to submit yet, you can save your assessment and come back later.
            </p>
          )
        end
      end
    end
  end
end
