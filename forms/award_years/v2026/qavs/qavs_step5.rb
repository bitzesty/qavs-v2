# -*- coding: utf-8 -*-
class AwardYears::V2026::QaeForms
  class << self
    def qavs_step5
      @qavs_step5 ||= proc do
        notice %(
          <p class=govuk-body>Please note your answers are being saved automatically in the background.</p>
        )

        header :local_assessment_general_header, "General information" do
          context %(
            <p class=govuk-body>Thank you for conducting the local assessment for KAVS. Before starting the assessment, please read the full guidance for Lieutenancies document that can be downloaded from your dashboard page. This provides helpful tips on approaching the assessment and completing your report.<p>
            <p class=govuk-body><strong>Please note:</strong> The new KAVS administrative website has a downloadable Word version of the form that includes explanations and suggestions to help you complete it.</p>
          )
        end

        assessor_details :assessor_details, "Assessor's details" do
          sub_ref "E 1.1"
          form_hint "Please note, if a Deputy Lieutenant nominated the group or wrote a letter of support, they must not be involved in the assessment as this would present a conflict of interest."
          required
          sub_fields([
            { primary_assessor_name: "Full name of the first assessor" },
            { secondary_assessor_name: "Full name of the second assessor (if applicable)", ignore_validation: true }
          ])
        end


        text :nomination_local_assessment_form_nominee_name, "Group name" do
          header_context %(
            <p class=govuk-body>
              Questions 1.2 to 1.6 have information pre-filled by the nominator. Please double-check and amend as necessary. It's important that these details are correct so that we can contact the successful group leaders in confidence and use the right group name in any announcement.
            </p>
          )
          sub_ref "E 1.2"
          form_hint "Please check that the group name given by the nominator is correct."
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

        text :local_assessment_group_leader_email, "Email of the group leader or main contact" do
          sub_ref "E 1.5"
          form_hint "Please check that the details provided by the nominator are correct."
          required
          type "email"
          default_value :nominee_leader_email
          style "large"
        end

        text :local_assessment_group_leader_phone, "Telephone of the group leader or main contact" do
          sub_ref "E 1.6"
          form_hint "Please check that the details provided by the nominator are correct."
          required
          default_value :nominee_leader_telephone
        end

        options :group_details_confirmed, "Confirm group details" do
          sub_ref "E 1.7"
          required
          option "yes", "Yes"
          option "no", "No (please email any amendments to kingsaward@dcms.gov.uk)."
          context -> do
            %(
              <p class=govuk-body>The details above are still correct:</p>
            )
          end
        end

        confirm :group_eligibility_confirmed, "Confirm group's eligibility" do
          sub_ref "E 1.8"
          required
          text -> do
            %(
              I confirm that I have checked the group's eligibility for the award as per the criteria above (if you disagree, please email us at kingsaward@dcms.gov.uk).
            )
          end
          online_context %(
            <details class="govuk-details" data-module="eligibility-criteria">
              <summary class="govuk-details__summary">
                <span class="govuk-details__summary-text">
                  View eligibility criteria
                </span>
              </summary>
              <div class="govuk-details__text">
                <p class='govuk-hint'>The group must:</p>
                <ul class='govuk-list govuk-list--bullet govuk-hint'>
                  <li>be made up of three or more people</li>
                  <li>be based in the UK, Channel Islands or Isle of Man</li>
                  <li>have been in operation for at least three years before the date of nomination</li>
                  <li>have over half its volunteers eligible to reside in the UK</li>
                  <li>be led by volunteers, not by paid staff (we would normally expect at least half the group's members to be volunteers)</li>
                </ul>
                <p class='govuk-hint'>The group must not:</p>
                <ul class='govuk-list govuk-list--bullet govuk-hint'>
                  <li>have been nominated unsuccessfully for a KAVS award in the past 3 years</li>
                  <li>have already received a KAVS award</li>
                  <li>operate solely for the benefit of animals (unless it can demonstrate that its work provides significant other benefits to the local community)</li>
                </ul>
                <p class='govuk-hint'>Important</p>
                <ul class='govuk-list govuk-list--bullet govuk-list--spaced govuk-hint'>
                  <li>Groups must provide specific and direct benefits to a community through their work. Groups will be considered ineligible where their sole purpose is to support one or more other groups that provide direct benefits (for example, fundraising and providing grants or other resources).</li>
                  <li>KAVS awards are not intended for national organisations. A national group that has local branches would not itself be suitable. A group can be nominated if it is a branch of, or affiliated to, a larger regional or national organisation. However, it will be expected to have initiated and developed a distinctive approach locally and be able to show a high degree of autonomy and self-determination.</li>
                  <li>Groups based within or in support of a public service (such as a hospital, police force or school) are eligible, but you will need to be able to demonstrate that:
                    <ul class='govuk-list govuk-list--bullet govuk-hint'>
                      <li>the group has a separate identity from the statutory organisation and is clearly under the leadership of volunteers, rather than simply following instructions from paid staff in the organisation</li>
                      <li>the group is an established, long-term volunteer group with its own unique identity and a governance structure, rather than being part of a wider scheme or a school-led volunteering initiative</li>
                    </ul>
                  </li>
                </ul>
              </div>
            </details>
          )
        end

        textarea :local_assessment_eligibility_comment, "Comments about eligibility (optional)" do
          sub_ref "E 1.9"
        end

        header :local_assessment_key_facts_header, "Key facts" do
        end

        number :local_assessment_form_volunteers_number, "Number of volunteers" do
          sub_ref "E 2.1"
          style "tiny"
          type "number"
          required
        end

        number :local_assessment_form_paid_staff_number, "Number of full time paid staff" do
          sub_ref "E 2.2"
          style "tiny"
          type "number"
          required
        end

        number :local_assessment_form_part_time_staff_number, "Number of part time paid staff" do
          sub_ref "E 2.3"
          style "tiny"
          type "number"
          required
        end

        number :local_assessment_form_beneficiaires_number, "Number of beneficiaries annually (can be approximate)" do
          sub_ref "E 2.4"
          style "tiny"
          type "number"
          required
        end

        header :local_assessment_citation_header, "Citation" do
        end

        textarea :l_citation_summary, "Provide a short citation summarising what the group does." do
          sub_ref "E 3.1"
          context %(
            <p class='govuk-hint'>
              Please discuss with the group and provide a short summary of the group's work in one sentence. This will be used for the group's certificate if they eventually receive the King's Award for Voluntary Service. It should not include the group's name.
            </p>
          )
          online_context %(
            <p class='govuk-hint'>Citations typically use the present participle tense, whereby the verbs end in 'ing'. For example, “maintaining” instead of “maintain”. See the examples below.</p>
            <details class="govuk-details" data-module="citation-examples">
              <summary class="govuk-details__summary">
                <span class="govuk-details__summary-text">
                  View short citation examples
                </span>
              </summary>
              <div class="govuk-details__text">
                <ul class="govuk-list govuk-list--bullet govuk-hint">
                  <li>Maintaining [name of the park] for the benefit of the whole community.</li>
                  <li>Providing financial, social, health and education services to the local community.</li>
                  <li>Transforming a derelict stretch of the canal into a wildlife haven and a vibrant community facility.</li>
                  <li>Enabling disabled people of all ages to enjoy the therapeutic excitement of pony carriage driving.</li>
                  <li>Promoting wellbeing and reducing loneliness and isolation in [town or area].</li>
                </ul>
              </div>
            </details>
          )
          form_hint "The short citation must be a maximum of 100 characters, spaces and punctuation are included as characters. If the short citation is longer than 100 characters we may need to edit it without consulting the group so the certificates can be produced on schedule."
          required
          words_max 15
        end

        header :local_assessment_group_work_header, "Work of the group" do
        end

        textarea :nomination_local_assessment_form_provided_services, "Describe the range of services and activities provided by the group." do
          sub_ref "E 4.1"
          online_context %(
            <p class='govuk-hint'>Please do not rely purely on the description of the services in the nomination form. Find out all the services the group provides and give us a complete picture, emphasising any aspects that are particularly relevant for a KAVS because of the key role of volunteers.</p>
            <p class='govuk-hint'>If it is a project or a branch of a larger organisation, make sure this refers to the work of the project or the branch rather than the larger organisation.</p>
          )
          form_hint "Recommended 100 words."
          required
          rows 2
        end

        textarea :nomination_local_assessment_form_evidence_of_need, "Describe the need for the group's work and provide evidence." do
          sub_ref "E 4.2"
          online_context %(
            <p class='govuk-hint'>For example:
              <ul class="govuk-list govuk-list--bullet govuk-hint">
                <li>Describe the need, for example, gaps in local provision, lack of similar facilities.</li>
                <li>How and when was the need for the group’s work established.</li>
                <li>If the group actively reviews whether the need is still there and whether it is changing?</li>
                <li>Provide any facts or figures about the local area or target group and the level of need - for example, any local surveys or community audits.</li>
              </ul>
            </p>
          )
          required
        end

        textarea :nomination_local_assessment_form_benefits_made, "What difference does the group make in meeting the need described above? Please provide evidence." do
          sub_ref "E 4.3"
          online_context %(
            <p class='govuk-hint'>Please include direct benefits, but also any indirect benefits, such as preserving heritage or environment, promoting community cohesion among volunteers, or contributing to crime reduction.</p>
            <p class='govuk-hint'>Points to consider:
              <ul class="govuk-list govuk-list--bullet govuk-hint">
                <li>How has the group made a difference to individual people and the local community?</li>
                <li>Has the group done anything particularly different or innovative compared with similar groups?  What stands out about the group’s approach or impact?</li>
                <li>Any evidence, data, examples to show the impact, such as the number of people helped, visitor numbers, surveys.</li>
              </ul>
            </p>
          )
          required
        end

        textarea :nomination_local_assessment_form_makes_their_work_distinctive, "If they are a branch of a wider organisation, how has the group made its work distinctive from that of other groups in the organisation?" do
          sub_ref "E 4.4"
          online_context %(
            <p class='govuk-hint'>Points to consider:
              <ul class="govuk-list govuk-list--bullet govuk-hint">
                <li>How much control does the parent group have over the way the group runs? Does the group have the freedom to make their local approach distinctive? If so, how have they done that?</li>
                <li>Can they give examples of doing things better or differently from the other branches in their organisation?</li>
              </ul>
            </p>
          )
        end

        textarea :nomination_local_assessment_form_group_operation_timespan, "Describe whether the group operates all year round or just at certain times of the year, and explain how that affects the work pattern of volunteers." do
          sub_ref "E 4.5"
          context %(
            <p class='govuk-hint'>For example, the group may operate only during a festival or during school breaks (this is fine).</p>
          )
          online_context %(
            <p class='govuk-hint'>Explain how that influences the work of the volunteers. For example, some volunteers may work all year round with additional volunteers giving their time nearer to the event.</p>
          )
          required
        end

        textarea :nomination_local_assessment_form_local_challenges, "Describe the local area the group serves and any challenges the area faces." do
          sub_ref "E 4.6"
          online_context %(
            <p class='govuk-hint'>
              <ul class="govuk-list govuk-list--bullet govuk-hint">
                <li>Please be specific when describing the area. For example, if describing a rural setting, explain how far away the nearest large town is and its population size. Is it hard to muster volunteers for various reasons?</li>
                <li>Challenges may include deprivation, rural isolation, lack of community, unequal opportunities. Where possible, provide evidence - for example, if describing deprivation, you could use one of the online deprivation measures for a local postcode.</li>
              </ul>
            </p>
          )
          required
        end

        options :nomination_local_assessment_form_beneficiaries_based_abroad, "Are the group's beneficiaries based abroad or in more than one part of the UK?" do
          sub_ref "E 4.7"
          yes_no
          required
          pdf_context %(
            If the answer is 'no', please skip to section 5 - 'Role and status of volunteers'.
            If the answer is 'yes', please answer questions E4.8 and E4.9.
          )
        end

        options :nomination_local_assessment_form_group_based_locally, "If its beneficiaries live elsewhere, is the group itself based entirely locally?" do
          sub_ref "E 4.8"
          context %(
            <p class='govuk-hint'>KAVS is aimed at <u>local groups</u> of volunteers, so this question is to confirm that point.</p>
          )
          yes_no
          conditional :nomination_local_assessment_form_beneficiaries_based_abroad, "yes"
          required
        end

        textarea :nomination_local_assessment_form_how_benefits_local_and_abroad, "In what ways does its existence benefit the local community as well as people elsewhere?" do
          sub_ref "E 4.9"
          context %(
            <p class='govuk-hint'>For example, the group might provide regular educational talks in schools. It might also significantly improve community cohesiveness through organised events, combat loneliness through volunteering opportunities, or develop people's skills.  If this is the case, try to provide evidence to support this.</p>
          )
          conditional :nomination_local_assessment_form_beneficiaries_based_abroad, "yes"
          required
        end

        header :local_assessments_volunteers_header, "Role and status of volunteers" do
        end

        textarea :nomination_local_assessment_form_volunteer_roles, "What specific roles do the volunteers cover and what does this involve? Do any of these roles rely on the volunteers' input?" do
          sub_ref "E 5.1"
          required
        end

        textarea :nomination_local_assessment_form_volunteer_work_volume, "Please give an idea of the volume of work put in by volunteers." do
          sub_ref "E 5.2"
          online_context %(
            <p class='govuk-hint'>If possible, provide metrics, for example, 'x' number of volunteering hours are provided by 'y' volunteers each week; or the number of volunteers expressed as full time equivalents (FTEs).</p>
          )
          required
        end

        textarea :nomination_local_assessment_form_staff_roles, "What roles are covered by paid staff and what is their relationship to the volunteers (for example, supervision, support)?" do
          sub_ref "E 5.3"
          required
        end

        textarea :nomination_local_assessment_form_volunteer_representation_in_leadership_roles, "In what ways do volunteers play a central role in the group's leadership?" do
          sub_ref "E 5.4"
          online_context %(
            <p class='govuk-hint'>We are looking for volunteer-led groups where volunteers have a key input in decision making at all levels. Please look for evidence that volunteers are leading the work, setting its direction and acting as an inspiration to the rest of the group; also that volunteers at all levels of the organisation have a voice. If there are paid staff, they should be supporting rather than directing the work.</p>
          )
          required
        end

        textarea :nomination_local_assessment_form_election_procedures, "What are the procedures for electing and refreshing the governing body or leadership of the group?" do
          sub_ref "E 5.5"
          required
        end

        header :local_assessment_group_organisation_evidence_header, "Evidence of a well-run organisation" do
          context %(
            <p class='govuk-hint'>Before your visit to the group, it is helpful to check how the group is set up, for example, unconstituted group, registered charity, community interest company, as the statutory requirements and published information about the group will be different in each case. The KAVS guidance for Lieutenancies, which can be downloaded from your dashboard page, provides details about key things to check and how to do this.</p>
          )
        end

        textarea :nomination_local_assessment_form_wider_affiliations, "Describe if and how the group is affiliated to any wider group?" do
          sub_ref "E 6.1"
          online_context %(
            <p class='govuk-hint'>Points to consider</p>
            <ul class="govuk-list govuk-list--bullet govuk-hint">
              <li>What is the relationship between the nominated group and the wider group? For example, a branch, member, or partner?</li>
              <li>Does the larger group control the activity of the nominated group, and if so, what aspects?</li>
              <li>To what degree does the wider group give the nominated group autonomy, only acting as a source of advice or quality assurance for them?</li>
              <li>Are there any examples of ways in which the group has taken the initiative to develop its own approach?</li>
            </ul>
          )
          required
        end

        textarea :nomination_local_assessment_form_financial_stability_concerns, "Describe if there are any concerns about the group’s financial stability and ability to manage finances." do
          sub_ref "E 6.2"
          online_context %(
            <p class='govuk-hint'>Please note, you do not need to have a financial background to complete this aspect of the assessment. Guidance is available in the questions below and in our Lieutenancy guidance.</p>
            <details class="govuk-details" data-module="financial-stability-guidance">
              <summary class="govuk-details__summary">
                <span class="govuk-details__summary-text">
                  View guidance on assessing financial stability and group's ability to manage its finances.
                </span>
              </summary>
              <div class="govuk-details__text">
                <p class='govuk-body'><strong>Information you need when evaluating a larger organisation</strong></p>
                <ul class="govuk-list govuk-list--bullet">
                  <li>Annual accounts</li>
                  <li>Management accounts - the latest annual accounts may be almost a year old. Management accounts will provide up-to-date financial figures.</li>
                  <li>You may also consider reviewing cash flow forecasts and budgets.</li>
                </ul>
                <p class='govuk-body'><strong>Information you need when evaluating a small group</strong></p>
                <p class='govuk-body'>Up-to-date income and expenditure data could be in any form - for example, a manual entry book or spreadsheet.</p>
                <p class='govuk-body'>You could also ask to see the latest bank statements.</p>
                <p class='govuk-body'><strong>Evaluating financial stability</strong></p>
                <p class='govuk-body'>When evaluating the group's financial stability, the main consideration is whether the group can manage fluctuations in income. To do so, consider the following:</p>
                <ul class="govuk-list govuk-list--bullet">
                  <li>Is the group balancing its income with expenditure?</li>
                  <li>How reliable are the group's income sources? Are they over-reliant on a small number of income sources, and are any of them at risk?</li>
                  <li>Does the group have an appropriate level of cash reserves to meet immediate financial commitments, including recurring expenditures, such as rent and payroll?</li>
                  <li>Does the group have any debts or other fixed financial obligations? Can the group meet those obligations?</li>
                </ul>
                <p class='govuk-body'><strong>Evaluating the group's ability to manage finances effectively</strong></p>
                <p class='govuk-body'>Is the group maintaining proper accounting records that are appropriate for their size and circumstances?</p>
                <p class='govuk-body'>In the case of a formally registered or incorporated group, are they submitting their accounts on time to their official registering body, for example, Charity Commission or Companies House? Are their finances published and discussed at an Annual General Meeting?</p>
                <p class='govuk-body'>Are the funds used for the purposes for which they are intended?</p>
              </div>
            </details>
            )
          required
        end

        textarea :nomination_local_assessment_form_funds_source, "Where does the group get its funds from?" do
          sub_ref "E 6.3"
          online_context %(
            <p class='govuk-hint'>Describe the main sources of the group's income. Are these income sources at risk? Are there any plans in place to mitigate those risks?</p>
          )
          required
        end


        textarea :nomination_local_assessment_form_safeguarding_procedures, "Describe what safeguarding procedures are in place to ensure that children and adults at risk are well protected and whether these procedures are sufficient." do
          sub_ref "E 6.4"
          online_context %(
            <p class='govuk-hint'>This may include criminal record checks, a child-protection policy, specialised training and insurance indemnity.</p>
            <p class='govuk-hint'>Points to consider:</p>
            <ul class="govuk-list govuk-list--bullet govuk-hint">
              <li>Does the group work with children or adults at risk? If not directly, might the volunteers have contact with them without a responsible adult or carer present?</li>
              <li>Does the group have a safeguarding policy, which is a document that outlines how they will keep children or adults at risk safe? If so, how often is the policy reviewed?</li>
            </ul>
            <p class='govuk-hint'>Please note, even if the group doesn’t work directly with children or adults at risk, they might deal with them as visitors, for example, in museums, and therefore should have a clear policy setting out their approach.</p>
          )
          required
        end

        textarea :nomination_local_assessment_form_adequate_insurance, "Describe if the group has adequate insurance to cover volunteers and members of the public with whom they interact." do
          sub_ref "E 6.5"
          online_context %(
            <p class='govuk-hint'>Points to consider:</p>
            <ul class="govuk-list govuk-list--bullet govuk-hint">
              <li>Which, if any, aspects of the group’s work require insurance? This may include public or employee liability insurance.</li>
              <li>Are specific insurances needed? For example, are volunteer drivers covered in case of accidents?</li>
            </ul>
          )
          required
        end

        textarea :nomination_local_assessment_form_relevant_accreditions, "If relevant to the services delivered, has the group been accredited by a professional body or regulator? If so, please specify." do
          sub_ref "E 6.6"
          online_context %(
            <p class='govuk-hint'>For example, Ofsted, Care Quality Commission, HSE.</p>
          )
          required
        end

        textarea :nomination_local_assessment_form_quality_mark, "Has the group achieved any quality mark? If so, please specify." do
          sub_ref "E 6.7"
          online_context %(
            <p class='govuk-hint'>For example, from a national sports body or a national umbrella organisation.</p>
          )
          required
        end

        textarea :nomination_local_assessment_form_other_recognition, "Has the group achieved any other recognition or gained any awards either nationally or locally?" do
          sub_ref "E 6.8"
          required
        end

        textarea :nomination_local_assessment_form_involvement_from_local_bodies, "Describe if any local bodies have any involvement or support in the activities of the group." do
          sub_ref "E 6.9"
          online_context %(
            <p class='govuk-hint'>This may include the local authority, police, health, faith, or other community organisations.</p>
            <p class='govuk-hint'>Please check the views of any relevant authorities and state whether:</p>
            <ul class="govuk-list govuk-list--bullet govuk-hint">
              <li>The group has a good reputation with local authorities and community organisations;</li>
              <li>The group works in partnership with any local bodies? If so, do these organisations consider the partnership to be positive and constructive?</li>
            </ul>
          )
          required
        end

        textarea :nomination_local_assessment_form_adverse_information, "As far as you are aware, is there any adverse information that might affect the reputation of the group or its volunteers?" do
          sub_ref "E 6.10"
          online_context %(
            <ul class="govuk-list govuk-list--bullet govuk-hint">
              <li>Are the group or volunteers involved in any disputes or other complaint procedures? This could include vexatious complainants.</li>
              <li>Is there any negative publicity about them?</li>
            </ul>
            <p class='govuk-hint'>We recommend that you conduct an internet search, check local press sites and social media. You can then explore any issues with the group. It is important to spot any potential reputational issues at an early stage even if they now seem to be resolved, as we need to be aware of any potential criticism of the group, its leadership or its members, that might bring the Award into disrepute.</p>
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
          online_context %(
            <p class='govuk-hint'>This may include encouraging people from a range of ages, backgrounds, ethnicities, and abilities who might be marginalised.  For example, they may do so by placing leaflets in social centres or libraries, posting welcoming messages on social media or websites or providing training opportunities for unemployed volunteers.</p>
          )
          required
        end

        textarea :nomination_local_assessment_form_services_accessibility, "How does the group make its services accessible to the widest range of beneficiaries?" do
          sub_ref "E 7.3"
          online_context %(
            <p class='govuk-hint'>For example, by improving physical access to buildings, adjusting opening hours or means of contact and providing materials in a second language or alternative format. Does it reach out to different communities, people with mental health conditions, disabled people, lonely or isolated people etc?</p>
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
            <p class='govuk-hint'>In other words, are they likely to be among the best in the UK? If you are unsure how to judge this, ask the group leader for their view.</p>
          )
          required
        end

        options :nomination_local_assessment_form_member_worthy_of_honour, "Would you recommend any individual for a national Honour?" do
          sub_ref "E 8.3"
          context %(
            <p class='govuk-hint'>Please note, recommending an individual for a national Honour doesn't affect the group's chances of receiving the KAVS in any way.</p>
          )
          yes_no
          required
        end

        text :nomination_local_assessment_worthy_of_honour_name, "Please give the name of the person you are recommending" do
          sub_ref "E 8.4"
          conditional :nomination_local_assessment_form_member_worthy_of_honour, "yes"
          required
          style "medium"
        end

        textarea :nomination_local_assessment_worthy_of_honur_reasons, "Explain in a short paragraph why they might merit this." do
          sub_ref "E 8.5"
          conditional :nomination_local_assessment_form_member_worthy_of_honour, "yes"
          online_context %(
            <p class='govuk-hint'>The KAVS team will pass this information onto the DCMS Honours team. The Honours Team might get in touch with you in due course if they need your help to produce a citation (including personal details such as date of birth, address, email and telephone number).</p>
          )
          required
          words_max 50
        end

        assessor_details :assessor_nominating_member_worthy_of_honour, "Assessor recommending an individual for a national Honour details" do
          sub_ref "E 8.6"
          required
          conditional :nomination_local_assessment_form_member_worthy_of_honour, "yes"
          sub_fields([
            { full_name: "Full name" },
            { email: "Email address" },
            { phone: "Phone number (optional)", ignore_validation: true }
          ])
          pdf_context %(
            Answer this question if you selected 'Yes' in question E8.3.
          )
        end

        textarea :nomination_local_assessment_form_citation_full, "Lord-Lieutenant Citation" do
          sub_ref "E 9"
          required
          words_max 600
          context %(
            <p class='govuk-hint'>The purpose of the Lord-Lieutenant's citation is to summarise the local panel's opinion about the nominated group and to explain the decision to recommend or not recommend it. If the decision is to recommend, these opinions will be beneficial to the National Assessment Committee when making their judgements.</p>
            <p class='govuk-hint'>Detailed guidance, which you can download from your dashboard page, provides more advice about drafting the citation. However, key things to know when recommending a group to the national assessors are:</p>
            <ul class='govuk-list govuk-list--bullet govuk-list--spaced govuk-hint'>
              <li>The citation does not need to repeat the detail provided in the nomination and local assessment report, since the national assessors will have studied this material carefully as well.</li>
              <li>Instead, the citation should try to capture what is exceptional about this particular group.</li>
              <p>For example:</p>
                <ul class='govuk-list govuk-list--bullet govuk-hint'>
                  <li>the impact it has made on local people, particularly if the local context is challenging;</li>
                  <li>the ways in which its work or approach is distinctive or different from other groups doing similar things;</li>
                  <li>anything outstanding about the way the group is run;</li>
                  <li>any exemplary qualities in the volunteers themselves.</li>
                </ul>
              <li>The citation should be around 400-600 words. It should not be longer than that, but don't make it too short either, as this is an opportunity to bring the group to life for the national assessors.</li>
            </ul>
            <p class='govuk-hint'>You can also find more detailed information in the KAVS guidance for Lieutenancies.
          )
          pdf_context %(
            The purpose of the Lord-Lieutenant's citation is to summarise the local panel's opinion about the nominated group and to explain the decision to recommend or not recommend it.  If the decision is to recommend, then these opinions will be beneficial to the National Assessment Committee when making their judgements.

            Detailed guidance, which you can download from your dashboard page, provides more advice about drafting the citation. However, key things to know when recommending a group to the national assessors are:
              \u2022 The citation does not need to repeat the detail provided in the nomination and local assessment report, since the national assessors will have studied this material carefully as well.
              \u2022 Instead, the citation should try to capture what is exceptional about this particular group.

              For example:
                \u25E6 the impact it has made on local people, particularly if the local context is challenging;
                \u25E6 the ways in which its work or approach is distinctive or different from other groups doing similar things;
                \u25E6 anything outstanding about the way the group is run;
                \u25E6 any exemplary qualities in the volunteers themselves.

              \u2022 The citation should be around 400-600 words. It should not be longer than that, but don't make it too short either, as this is an opportunity to bring the group to life for the national assessors.

            You can also find more detailed information in the KAVS guidance for Lieutenancies
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
            <p class='govuk-body'>
              If you have answered all the questions, you can submit your assessment now. You will be able to edit it any time before [LIEUTENANT_SUBMISSION_ENDS_TIME].
            </p>
            <p class='govuk-body'>
              If you are not ready to submit yet, you can save your assessment and come back later.
            </p>
          )
          alternative_notices [%(
              <p class='govuk-body'>
                You will be able to edit the assessment any time before [LIEUTENANT_SUBMISSION_ENDS_TIME].
              </p>
            ),%(
            <p class='govuk-body'>
              <strong>
                Only main lieutenancy office users can submit the assessment.
              </strong>
            </p>
            <p class='govuk-body'>
              Please save your assessment and inform your main point of contact at the lieutenancy office that it is ready for their review.
            </p>
          )]
        end
      end
    end
  end
end
