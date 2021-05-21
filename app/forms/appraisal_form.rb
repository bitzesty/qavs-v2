# -*- coding: utf-8 -*-
class AppraisalForm

  #
  # THIS NEED TO BE UPDATED EACH YEAR
  #
  SUPPORTED_YEARS = [2022]

  RAG_OPTIONS_2022 = [
    %w(Red negative),
    %w(Amber average),
    %w(Green positive)
  ]

  CSR_RAG_OPTIONS_2022 = [
    ["Weak (0-15)", "negative"],
    ["Satisfactory (16-31)", "average"],
    ["Exceptional (32-50)", "positive"]
  ]

  STRENGTH_OPTIONS_2022 = [
    ["Insufficient Information Supplied", "neutral"],
    ["Priority Focus for Development", "negative"],
    ["Positive - Scope for Ongoing Development", "average"],
    ["Key Strength", "positive"]
  ]

  VERDICT_OPTIONS_2022 = [
    ["Not Recommended", "negative"],
    ["Reserved", "average"],
    ["Recommended", "positive"]
  ]

  def self.rag_options_for(object, section)
    options = if section.desc.include?("corporate_social_responsibility")
      const_get("CSR_RAG_OPTIONS_#{object.award_year.year}")
    else
      const_get("RAG_OPTIONS_#{object.award_year.year}")
    end

    option = options.detect do |opt|
      opt[1] == object.public_send(section.rate)
    end || ["Select RAG", "blank"]

    OpenStruct.new(
      options: options,
      option: option
    )
  end

  def self.non_rag_options_for(object, section)
  end

  def self.strength_options_for(object, section)
    year = object.award_year.year

    options = const_get("STRENGTH_OPTIONS_#{year}")

    option = options.detect do |opt|
      opt[1] == object.public_send(section.rate)
    end || ["Select Key Strengths and Focuses", "blank"]

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

  RAG_ALLOWED_VALUES = [
    "negative",
    "average",
    "positive"
  ]

  NON_RAG_ALLOWED_VALUES = [
    "negative",
    "average",
    "positive"
  ]

  STRENGTHS_ALLOWED_VALUES = [
    "neutral",
    "negative",
    "average",
    "positive"
  ]

  VERDICT_ALLOWED_VALUES = [
    "negative",
    "average",
    "positive"
  ]

  QAVS_2022 = {
    mobility_organisation_aiming_to_achieve: {
      type: :rag,
      label: "The Social Mobility programme and its context:",
      position: 0
    },
    mobility_embedding_info: {
      type: :rag,
      label: "Embedding the programme & Organisational culture:",
      position: 1
    },
    mobility_impact_of_the_programme: {
      type: :rag,
      label: "Impact of the programme:",
      position: 2
    },
    corporate_social_responsibility: {
      type: :rag,
      label: "Corporate social responsibility:",
      position: 3
    },
    verdict: {
      type: :verdict,
      label: "Overall verdict:",
      position: 4
    }
  }.freeze

  MODERATED_2022 = {
    verdict: {
      type: :verdict,
      label: "Overall verdict:"
    }
  }


  CASE_SUMMARY_METHODS_2022 = [
    :application_background_section_desc
  ]

  ALL_FORMS_2022 = [QAVS_2022]

  def self.rate(key)
    "#{key}_rate"
  end

  def self.desc(key)
    "#{key}_desc"
  end

  def self.meths_for_award_type(form_answer, moderated = false)
    award_type = form_answer.award_type
    award_year = form_answer.award_year

    if moderated
      assessment_types = [:verdict]
    else
      assessment_types = [:rag, :non_rag, :verdict]
    end
    const_get("#{award_type.upcase}_#{award_year.year}").map do |k, obj|
      methods = Array.new
      methods << Array(rate(k)) if ((!moderated && (obj[:type] != :non_rag)) || (moderated && obj[:type] == :verdict))
      methods << desc(k) if assessment_types.include?(obj[:type])
      methods
    end.flatten.map(&:to_sym)
  end

  def self.diff(form_answer, moderated = false)
    award_year = form_answer.award_year
    (all.map(&:to_sym) - meths_for_award_type(form_answer, moderated)).uniq - const_get("CASE_SUMMARY_METHODS_#{award_year.year}")
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

      out += const_get("CASE_SUMMARY_METHODS_#{year}")
    end

    out.uniq
  end

  def self.struct(form_answer, f = nil)
    meth = form_answer.respond_to?(:award_type_slug) ? :award_type_slug : :award_type
    year = form_answer.award_year.year

    # Assessor assignment
    moderated = (f && f.object && f.object.position == "moderated")

    list = if moderated
      const_get("MODERATED_#{year}")
    else
      const_get("#{form_answer.public_send(meth).upcase}_#{year}")
    end

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
