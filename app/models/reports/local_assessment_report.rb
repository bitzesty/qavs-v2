# coding: utf-8
class Reports::LocalAssessmentReport < Reports::QavsBase
  MAPPING = [
    {
      label: "Award year",
      method: :award_year,
    },
    {
      label: "Status",
      method: :state,
    },
    {
      label: "Group name",
      method: :company_or_nominee_name,
    },
    {
      label: "Group leader name",
      method: :group_leader_name,
    },
    {
      label: "Group leader phone",
      method: :group_leader_phone,
    },
    {
      label: "Group leader email",
      method: :group_leader_email,
    },
    {
      label: "Group address building",
      method: :group_address_building,
    },
    {
      label: "Group address street",
      method: :group_address_street,
    },
    {
      label: "Group address town/city",
      method: :group_address_city,
    },
    {
      label: "Group address county",
      method: :group_address_county,
    },
    {
      label: "Group address postcode",
      method: :group_address_postcode,
    },
    {
      label: "Ceremonial county",
      method: :ceremonial_county,
    },
    {
      label: "Region",
      method: :region,
    },
    {
      label: "Group activity 1",
      method: :nominee_activity,
    },
    {
      label: "Group activity 2",
      method: :secondary_activity,
    },
    {
      label: "Assigned Sub-Group",
      method: :sub_group,
    },
    {
      label: "Primary assessor name",
      method: :primary_assessor_name,
    },
    {
      label: "Secondary assessor name",
      method: :secondary_assessor_name,
    },
    {
      label: "Local assessment: Group name",
      method: :la_nominee_name,
    },
    {
      label: "Local assessment: Group Leader name",
      method: :la_group_leader,
    },
    {
      label: "Local assessment: Group Leader position",
      method: :la_group_leader_position,
    },
    {
      label: "Local assessment: Group Leader address building",
      method: :la_group_address_building,
    },
    {
      label: "Local assessment: Group Leader address street",
      method: :la_group_address_street,
    },
    {
      label: "Local assessment: Group Leader address city",
      method: :la_group_address_city,
    },
    {
      label: "Local assessment: Group Leader address county",
      method: :la_group_address_county,
    },
    {
      label: "Local assessment: Group Leader address postcode",
      method: :la_group_address_postcode,
    },
    {
      label: "Local assessment: Group Leader email",
      method: :la_group_leader_email,
    },
    {
      label: "Local assessment: Group Leader phone",
      method: :la_group_leader_phone,
    },
    {
      label: "Local assessment: Group details confirmed",
      method: :la_group_details_confirmed,
    },
    {
      label: "Local assessment: Eligibility confirmed",
      method: :la_group_eligibility_confirmed,
    },
    {
      label: "Local assessment: Eligibility comment",
      method: :la_eligibility_comment,
    },
    {
      label: "Local assessment: Short citation",
      method: :la_citation_summary,
    },
    {
      label: "Local assessment: The work of the group",
      method: :la_work_of_the_group,
    },
    {
      label: "Local assessment: LL Citation",
      method: :la_full_citation_full,
    },
    {
      label: "Local assessment: Individual honours. worthy of a national Honour?",
      method: :la_form_member_worthy_of_honour,
    },
    {
      label: "Local assessment: Individual honours. Name",
      method: :la_worthy_of_honour_name,
    },
    {
      label: "Local assessment: Individual honours. Reasons",
      method: :la_worthy_of_honur_reasons,
    },
    {
      label: "Local assessment: Individual honours. Assessor's Full Nmae",
      method: :la_nominating_member_worthy_of_honour_full_name,
    },
    {
      label: "Local assessment: Individual honours. Assessor's email",
      method: :la_nominating_member_worthy_of_honour_email,
    },
    {
      label: "Local assessment: Individual honours. Assessor's phone",
      method: :la_nominating_member_worthy_of_honour_phone,
    }
  ]

  private

  def mapping
    MAPPING
  end
end
