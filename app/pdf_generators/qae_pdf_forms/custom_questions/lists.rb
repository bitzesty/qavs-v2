module QaePdfForms::CustomQuestions::Lists
  LIST_TYPES = [
    QAEFormBuilder::AwardHolderQuestion,
    QAEFormBuilder::PositionDetailsQuestion
  ]
  AWARD_HOLDER_LIST_HEADERS = [
    "Award/personal honour title",
    "Year",
    "Details"
  ].freeze
  AWARD_APPLICATIONS_LIST_HEADERS = [
    "Award",
    "Year",
    "Outcome"
  ].freeze
  NOMINATION_AWARD_LIST_HEADERS = [
    "Award/personal honour title",
    "Details"
  ].freeze
  POSITION_LIST_HEADERS = [
    "Name",
    "Start Date",
    "End Date",
    "Ongoing",
    "Details"
  ].freeze
  UNDEFINED_CELL_VALUE = "Undefined".freeze

  def render_list
    if q_visible? && humanized_answer.present?
      render_multirows_table(list_headers, list_rows)

      if list_rows.blank?
        form_pdf.default_bottom_margin
        render_word_limit
      end
    else
      render_word_limit
    end
  end

  def list_headers
    case question.delegate_obj
    when QAEFormBuilder::AwardHolderQuestion
      if question.award_years_present
        AWARD_HOLDER_LIST_HEADERS
      else
        NOMINATION_AWARD_LIST_HEADERS
      end
    when QAEFormBuilder::QueenAwardApplicationsQuestion
      AWARD_APPLICATIONS_LIST_HEADERS
    when QAEFormBuilder::PositionDetailsQuestion
      POSITION_LIST_HEADERS
    else
      raise "[#{self.class.name}] Unrecognized list type!"
    end
  end

  def queen_award_holder_query_conditions(prepared_item)
    if prepared_item["category"].present? && prepared_item["year"].present?
      [
        prepared_item["category"],
        prepared_item["year"]
      ]
    end
  end

  def award_applications_query_conditions(item)
    category = item["category"].presence && QaePdfForms::General::QuestionPointer::PREVIOUS_AWARDS[item["category"]]
    outcome = item["outcome"].presence && question.outcomes.detect { |o| o.value == item["outcome"] }.try(:text)

    [
      item["category"],
      item["year"],
      item["outcome"]
    ]
  end

  def award_holder_query_conditions(prepared_item)
    if prepared_item["title"].present?
      if question.award_years_present
        [
          prepared_item["title"],
          prepared_item["year"],
          prepared_item["details"]
        ]
      else
        [
          prepared_item["title"],
          prepared_item["details"]
        ]
      end
    end
  end

  def position_details_query_conditions(prepared_item)
    if prepared_item["name"].present?
      [
        prepared_item["name"],
        position_date(prepared_item['start_month'], prepared_item['start_year']),
        position_date(prepared_item['end_month'], prepared_item['end_year']),
        prepared_item["ongoing"].to_s == "1" ? "yes" : "no",
        prepared_item["details"]
      ]
    end
  end

  def position_date(month, year)
    [
      month || '-',
      year || '-'
    ].join("/")
  end

  def subsidiaries_associates_plants_query_conditions(prepared_item)
    if prepared_item["name"].present?
      [
        prepared_item["name"],
        prepared_item["location"],
        prepared_item["employees"],
        prepared_item["description"]
      ]
    end
  end

  def list_rows
    if humanized_answer.present?
      humanized_answer.map do |item|
        case question.delegate_obj
        when QAEFormBuilder::AwardHolderQuestion
          award_holder_query_conditions(item)
        when QAEFormBuilder::QueenAwardApplicationsQuestion
          award_applications_query_conditions(item)
        when QAEFormBuilder::QueenAwardHolderQuestion
          queen_award_holder_query_conditions(item)
        when QAEFormBuilder::PositionDetailsQuestion
          position_details_query_conditions(item)
        when QAEFormBuilder::SubsidiariesAssociatesPlantsQuestion
          subsidiaries_associates_plants_query_conditions(item)
        end
      end.compact
    end
  end
end
