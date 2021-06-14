module FeedbackPdfs::General::DataPointer
  COLOR_LABELS = %w(positive average negative neutral)

  POSITIVE_COLOR = "6B8E23"
  AVERAGE_COLOR = "DAA520"
  NEGATIVE_COLOR = "FF0000"
  NEUTRAL_COLOR = "ECECEC"

  COLOR_LABELS.each do |label|
    AppraisalForm::SUPPORTED_YEARS.each do |year|
      const_set("#{label.upcase}_LABELS_#{year}", AppraisalForm.group_labels_by(year, label))
    end
  end

  def undefined_value
    FeedbackPdfs::Pointer::UNDEFINED_VALUE
  end

  def feedback_table_headers
    [
      [
        "",
        "Key strengths",
        "Information to strengthen the application"
      ]
    ]
  end

  def feedback_entries
    FeedbackForm.fields_for_award_type(form_answer).map do |key, value|
      if value[:type] != :strengths
        [
          value[:label].delete(":"),
          data["#{key}_strength"] || undefined_value,
          data["#{key}_weakness"] || undefined_value
        ]
      end
    end.compact
  end

  def strengths_entries
    FeedbackForm.fields_for_award_type(form_answer).map do |key, value|
      if value[:type] == :strengths
        [
          value[:label].delete(":"),
          rag(key)
        ]
      end
    end.compact
  end

  def render_data!
    table_items = feedback_entries

    render_overall_summary!
    render_headers(feedback_table_headers, {
      0 => 130,
      1 => 300,
      2 => 337
    })
    render_table(table_items, {
      0 => 130,
      1 => 300,
      2 => 337
    })
  end

  def render_overall_summary!
    pdf_doc.move_down 30.mm
    render_table([["Overall Summary", data["overall_summary"]]], {
      0 => 130,
      1 => 637
    })
  end

  def render_headers(table_lines, column_widths)
    pdf_doc.move_down 10.mm
    pdf_doc.table table_lines, row_colors: %w(F0F0F0),
                               cell_style: { size: 12, font_style: :bold },
                               column_widths: column_widths
  end

  def rag(key)
    if data["#{key}_rate"].present?
      val = AppraisalForm.const_get("STRENGTH_OPTIONS_#{form_answer.award_year.year}").detect do |el|
        el[1] == data["#{key}_rate"]
      end

      val.present? ? val[0] : undefined_value
    else
      undefined_value
    end
  end
end
