# coding: utf-8
class Reports::NominationsReport < Reports::QavsBase
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
      label: "Year founded",
      method: :nominee_established_date,
    },
    {
      label: "Please summarise the activities of the group",
      method: :group_activities,
    },
    {
      label: "Who are the beneficiaries (the people it helps) and where do they live?",
      method: :beneficiaries,
    },
    {
      label: "What are the benefits of the group's work?",
      method: :benefits,
    },
    {
      label: "This Award is specifically for groups that rely on significant and committed work by volunteers. Please explain what the volunteers do and what makes this particular group of volunteers so impressive?",
      method: :volunteers,
    },
  ]

  private

  def mapping
    MAPPING
  end

  def sanitize_string(string)
    if string.present?
      ActionView::Base.full_sanitizer.sanitize(string.to_s.strip).gsub("\u00A0", "\u0020")
    else
      ""
    end
  end
end
