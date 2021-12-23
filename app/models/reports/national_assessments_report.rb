# coding: utf-8
class Reports::NationalAssessmentsReport < Reports::QavsBase
  attr_reader :year

  def initialize(scope, award_year)
    @scope = scope
    @year = award_year.year
  end

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

  def assessment_data
    data = []

    4.times do |i|
      index = i + 1

      data << {
        label: "Assessor #{index} name",
        method: "na_assessor_name_#{index}"
      }

      questions = AppraisalForm.const_get("QAVS_#{year}")

      questions.each do |key, options|
        case options[:type]
        when :rag
          data << {
            label: "#{options[:label]} Evaluation #{index}",
            method: "na_#{key}_rate_#{index}"
          }

          data << {
            label: "#{options[:label]} Notes #{index}",
            method: "na_#{key}_desc_#{index}"
          }
        when :verdict
          data << {
            label: "#{options[:label]} Decision #{index}",
            method: "na_#{key}_rate_#{index}"
          }

          data << {
            label: "#{options[:label]} Verdict Notes #{index}",
            method: "na_#{key}_desc_#{index}"
          }
        end
      end
    end

    data
  end

  def mapping
    MAPPING + assessment_data
  end

  def build_nomination(form_answer)
    Reports::Nomination.new(form_answer, year)
  end
end
