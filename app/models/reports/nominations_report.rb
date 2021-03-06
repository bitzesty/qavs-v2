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
    }
  ]

  private

  def mapping
    MAPPING
  end
end
