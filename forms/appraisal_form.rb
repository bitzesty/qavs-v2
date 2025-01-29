# -*- coding: utf-8 -*-
class AppraisalForm

  #
  # THIS NEED TO BE UPDATED EACH YEAR
  #
  SUPPORTED_YEARS = [2022, 2023, 2024, 2025, 2026]

  EVALUATION_OPTIONS_2022 = [
    ["Weak evidence", "weak"],
    ["Good evidence", "good"],
    ["Strong evidence", "strong"]
  ]

  EVALUATION_OPTIONS_2023 = [
    ["Weak evidence", "weak"],
    ["Good evidence", "good"],
    ["Strong evidence", "strong"]
  ]

  EVALUATION_OPTIONS_2024 = [
    ["Weak evidence", "weak"],
    ["Good evidence", "good"],
    ["Strong evidence", "strong"]
  ]

  EVALUATION_OPTIONS_2025 = [
    ["Weak evidence", "weak"],
    ["Good evidence", "good"],
    ["Strong evidence", "strong"]
  ]

  EVALUATION_OPTIONS_2026 = [
    ["Weak evidence", "weak"],
    ["Good evidence", "good"],
    ["Strong evidence", "strong"]
  ]

  VERDICT_OPTIONS_2022 = [
    ["Not Recommended", "not_recommended"],
    ["Recommended", "recommended"],
    ["Undecided", "undecided"]
  ]

  VERDICT_OPTIONS_2023 = [
    ["Not Recommended", "not_recommended"],
    ["Recommended", "recommended"],
    ["Undecided", "undecided"]
  ]

  VERDICT_OPTIONS_2024 = [
    ["Not Recommended", "not_recommended"],
    ["Recommended", "recommended"],
    ["Undecided", "undecided"]
  ]

  VERDICT_OPTIONS_2025 = [
    ["Not Recommended", "not_recommended"],
    ["Recommended", "recommended"],
    ["Undecided", "undecided"]
  ]

  VERDICT_OPTIONS_2026 = [
    ["Not Recommended", "not_recommended"],
    ["Recommended", "recommended"],
    ["Undecided", "undecided"]
  ]

  def self.evaluation_options_for(object, section)
    options = const_get("EVALUATION_OPTIONS_#{object.award_year.year}")

    option = options.detect do |opt|
      opt[1] == object.public_send(section.rate)
    end || ["", "blank"]

    OpenStruct.new(
      options: options,
      option: option
    )
  end

  def self.verdict_options_for(object, section)
    options = const_get("VERDICT_OPTIONS_#{object.award_year.year}")

    option = options.detect do |opt|
      opt[1] == object.public_send(section.rate)
    end || ["Select verdict", "blank"]

    OpenStruct.new(
      options: options,
      option: option
    )
  end

  EVIDENCE_ALLOWED_VALUES = [
    "negative",
    "average",
    "positive"
  ]

  VERDICT_ALLOWED_VALUES = [
    "not_recommended",
    "undecided",
    "recommended"
  ]

  QAVS_2022 = {
    good_impact: {
      type: :rag,
      label: "Good impact",
      position: 0
    },
    volunteer_led: {
      type: :rag,
      label: "Volunteer-led",
      position: 1
    },
    good_governance: {
      type: :rag,
      label: "Good governance",
      position: 2
    },
    exceptional_qualities: {
      type: :rag,
      label: "Exceptional qualities",
      position: 3
    },
    verdict: {
      type: :verdict,
      label: "Overall decision",
      position: 4
    }
  }.freeze

  QAVS_2023 = {
    good_impact: {
      type: :rag,
      label: "Good impact",
      position: 0
    },
    volunteer_led: {
      type: :rag,
      label: "Volunteer-led",
      position: 1
    },
    good_governance: {
      type: :rag,
      label: "Good governance",
      position: 2
    },
    exceptional_qualities: {
      type: :rag,
      label: "Exceptional qualities",
      position: 3
    },
    verdict: {
      type: :verdict,
      label: "Overall decision",
      position: 4
    }
  }.freeze

  QAVS_2024 = {
    good_impact: {
      type: :rag,
      label: "Good impact",
      position: 0
    },
    volunteer_led: {
      type: :rag,
      label: "Volunteer-led",
      position: 1
    },
    good_governance: {
      type: :rag,
      label: "Good governance",
      position: 2
    },
    exceptional_qualities: {
      type: :rag,
      label: "Exceptional qualities",
      position: 3
    },
    verdict: {
      type: :verdict,
      label: "Overall decision",
      position: 4
    }
  }.freeze

  QAVS_2025 = {
    good_impact: {
      type: :rag,
      label: "Good impact",
      position: 0
    },
    volunteer_led: {
      type: :rag,
      label: "Volunteer-led",
      position: 1
    },
    good_governance: {
      type: :rag,
      label: "Good governance",
      position: 2
    },
    exceptional_qualities: {
      type: :rag,
      label: "Exceptional qualities",
      position: 3
    },
    verdict: {
      type: :verdict,
      label: "Overall decision",
      position: 4
    }
  }.freeze

  QAVS_2026 = {
    good_impact: {
      type: :rag,
      label: "Good impact",
      position: 0
    },
    volunteer_led: {
      type: :rag,
      label: "Volunteer-led",
      position: 1
    },
    good_governance: {
      type: :rag,
      label: "Good governance",
      position: 2
    },
    exceptional_qualities: {
      type: :rag,
      label: "Exceptional qualities",
      position: 3
    },
    verdict: {
      type: :verdict,
      label: "Overall decision",
      position: 4
    }
  }.freeze

  ALL_FORMS_2022 = [QAVS_2022]
  ALL_FORMS_2023 = [QAVS_2023]
  ALL_FORMS_2024 = [QAVS_2024]
  ALL_FORMS_2025 = [QAVS_2025]
  ALL_FORMS_2026 = [QAVS_2026]

  def self.rate(key)
    "#{key}_rate"
  end

  def self.desc(key)
    "#{key}_desc"
  end

  def self.meths_for_award_type(form_answer)
    award_type = form_answer.award_type
    award_year = form_answer.award_year

    describable_assessment_type = :verdict

    const_get("#{award_type.upcase}_#{award_year.year}").map do |k, obj|
      methods = Array.new
      methods << Array(rate(k))
      methods << desc(k) if describable_assessment_type == obj[:type]
      methods
    end.flatten.map(&:to_sym)
  end

  def self.all
    out = []

    AppraisalForm::SUPPORTED_YEARS.map do |year|
      const_get("ALL_FORMS_#{year}").each do |form|
        form.each do |k, obj|
          out << rate(k).to_sym if [:strengths, :rag, :non_rag, :verdict].include?(obj[:type])
          # strengths doesn't have description
          out << desc(k).to_sym if [:rag, :non_rag, :verdict].include?(obj[:type])
        end
      end
    end

    out.uniq
  end

  def self.struct(form_answer, f = nil)
    meth = form_answer.respond_to?(:award_type_slug) ? :award_type_slug : :award_type
    year = form_answer.award_year.year

    list = const_get("#{form_answer.public_send(meth).upcase}_#{year}")

    list.sort_by { |k, v| v[:position] }
  end

  def self.rates(form_answer, type)
    struct(form_answer).select { |_, v| v[:type] == type }
  end

  class << self
    def group_labels_by(year, type)
      %w(rag csr_rag strength verdict).map do |label_type|
        const_get("#{label_type.upcase}_OPTIONS_#{year}").detect do |el|
          el[1] == type
        end
      end.compact
         .map { |el| el[0] }
         .flatten
    end
  end
end
