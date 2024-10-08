# -*- coding: utf-8 -*-
class QaePdfForms::General::QuestionPointer
  include QaePdfForms::CustomQuestions::ByYear
  include QaePdfForms::CustomQuestions::SupporterLists
  include QaePdfForms::CustomQuestions::CheckboxSeria
  include QaePdfForms::CustomQuestions::Textarea
  include FinancialTable

  NOT_CURRENCY_QUESTION_KEYS = %w(employees).freeze
  QUESTIONS_WITH_PDF_TITLES = %w(trading_figures_add).freeze
  SKIP_HEADER_HINT_KEYS = %w(head_of_business_header).freeze
  RENDER_INLINE_KEYS = %w(head_of_business_title).freeze

  attr_reader :form_pdf,
              :form_answer,
              :step,
              :question,
              :key,
              :answer,
              :humanized_answer,
              :sub_answers,
              :financial_pointer,
              :audit_data,
              :filled_answers,
              :step_questions,
              :questions_with_references,
              :non_header_questions

  PREVIOUS_AWARDS = { "innovation" => "Innovation",
                      "international_trade" => "International Trade",
                      "sustainable_development" => "Sustainable Development",
                      "social_mobility" => "Promoting Opportunity"
                    }

  ANSWER_FONT_START = "<color rgb='#{FormPdf::DEFAULT_ANSWER_COLOR}'>".freeze
  ANSWER_FONT_END = "</color>".freeze

  BLOCK_QUESTIONS = [
    QaeFormBuilder::UploadQuestion,
    QaeFormBuilder::ByYearsLabelQuestion,
    QaeFormBuilder::ByYearsQuestion,
    QaeFormBuilder::OneOptionByYearsLabelQuestion,
    QaeFormBuilder::OneOptionByYearsQuestion,
    QaeFormBuilder::SupportersQuestion,
    QaeFormBuilder::TextareaQuestion,
    QaeFormBuilder::TextQuestion
  ]

  def initialize(ops = {})
    ops.each do |k, v|
      instance_variable_set("@#{k}", v)
    end

    @key = question.key
    @answer = answer_by_key
    @humanized_answer = form_pdf.answer_based_on_type(key, answer) if answer.present?
    @sub_answers = fetch_sub_answers
    @financial_pointer = form_pdf.financial_pointer
    @audit_data = form_pdf.pdf_blank_mode.present? ? [] : financial_pointer.data
    @filled_answers = form_pdf.filled_answers
    @step_questions = step.step_questions
    @form_answer = form_pdf.form_answer

    set_non_header_questions
    set_questions_with_references
  end

  def set_questions_with_references
    @questions_with_references = non_header_questions.select do |q|
      q.ref.present? || q.sub_ref.present?
    end
  end

  def set_non_header_questions
    @non_header_questions = form_pdf.all_questions.select do |q|
      !q.delegate_obj.is_a?(QaeFormBuilder::HeaderQuestion)
    end
  end

  def q_visible?
    step.award_form[question.key].visible?
  end

  def render!
    if humanized_answer.present?
      question_block
    else
      sub_answers.any? ? complex_question : question_block
    end

    render_bottom_space
  end

  def render_bottom_space
    if question.delegate_obj.class.to_s != "QaeFormBuilder::HeaderQuestion" ||
       question.classes != "regular-question" ||
       question.classes == "application-notice help-notice"

      form_pdf.default_bottom_margin
    end
  end

  def answer_by_key
    form_pdf.answers[key]
  end

  def fetch_sub_answers
    res = []

    required_sub_fields = question.required_sub_fields rescue []
    sub_fields = question.sub_fields rescue []
    merged_sub_fields = (required_sub_fields + sub_fields).flatten.uniq

    merged_sub_fields.each do |sub_field|
      sub_field_key = sub_field.keys.first
      sub_answer = form_pdf.fetch_answer_by_key("#{key}_#{sub_field_key}")

      res << [
        sub_field[sub_field_key],
        sub_answer ? form_pdf.answer_based_on_type(sub_field_key, sub_answer) : ""
      ]
    end

    res
  end

  def question_block
    render_validation_block
    render_question_title_with_ref_or_not

    render_header_hint
    render_pdf_hint
    render_context_and_answer_blocks
  end

  def render_pdf_hint
    if question.form_hint.present?
      form_pdf.indent 25.mm do
        form_pdf.render_text question.form_hint,
                             style: :italic
      end
    end
    if question.additional_pdf_context.present?
      form_pdf.indent 25.mm do
        form_pdf.render_text question.additional_pdf_context,
                             style: :italic
      end
    end
  end

  def render_header_hint
    if question.delegate_obj.is_a?(QaeFormBuilder::HeaderQuestion) &&
      (question.ref.present? || question.sub_ref.present?) &&
      SKIP_HEADER_HINT_KEYS.exclude?(question.key.to_s)

      form_pdf.indent 25.mm do
        form_pdf.render_text "Please note #{(question.ref || question.sub_ref).delete(" ")} is just a heading for the following sub-questions.",
                             style: :italic
      end
    end
  end

  def render_question_title_with_ref_or_not
    if (question.delegate_obj.ref.present? || question.delegate_obj.sub_ref.present?) &&
       !question.delegate_obj.is_a?(QaeFormBuilder::SupportersQuestion)
      render_question_with_ref
    else
      render_question_without_ref
    end
  end

  def render_context_and_answer_blocks
    if question.delegate_obj.is_a?(QaeFormBuilder::SupportersQuestion)
      form_pdf.indent 11.mm do
        render_question_context
        render_question_help_note
        render_question_hints

        question_answer(question)
      end
    # for inline questions answer is rendered with the title
    elsif RENDER_INLINE_KEYS.exclude?(question.key.to_s)
      form_pdf.indent 25.mm do
        render_question_context
        render_question_help_note
        render_question_hints

        question_answer(question)
      end
    end
  end

  def render_question_with_ref
    ref = question.ref || question.sub_ref

    form_pdf.indent 11.mm do
      form_pdf.render_text "#{ref.delete(' ')}.",
                           style: :bold, width: 20.mm
    end

    form_pdf.move_cursor_to form_pdf.cursor + 10.mm

    if question.escaped_title.present? &&
      (!pdf_title_question? || (pdf_title_question? && list_rows.blank?))
      form_pdf.indent 25.mm do
        form_pdf.render_text question.escaped_title,
                             style: :bold

      if question.can_have_parent_conditional_hints? && question.have_conditional_parent?
        render_info_about_conditional_parent
      end

        render_question_sub_title
      end
    end
  end

  def pdf_title_question?
    QUESTIONS_WITH_PDF_TITLES.include?(question.key.to_s)
  end

  def render_question_without_ref
    if question.escaped_title.present?
      if question.classes == "regular-question"
        form_pdf.indent 25.mm do
          if question_block_type(question) == "inline" && humanized_answer.present?
            inline_question_text = question.escaped_title
            inline_question_text += ": "
            inline_question_text += ANSWER_FONT_START
            inline_question_text += humanized_answer
            inline_question_text += ANSWER_FONT_END

            form_pdf.text inline_question_text,
                          inline_format: true
          else
            form_pdf.text "#{question.escaped_title}:"
          end
        end
      else
        form_pdf.indent 11.mm do
          form_pdf.render_text "#{question.escaped_title}",
                               style: :bold
        end
      end
    end
  end

  def urn_blank_or_pdf_blank_mode?
    (form_pdf.form_answer.urn.blank? || form_pdf.pdf_blank_mode.present?)
  end

  def render_question_context
    if urn_blank_or_pdf_blank_mode?
      if question.pdf_context_with_header_blocks.present?

        question.pdf_context_with_header_blocks.map do |text_block|
          if text_block[0] == :bold
            form_pdf.render_text text_block[1], style: :bold
          elsif text_block[0] == :italic
            form_pdf.render_text text_block[1], style: :italic
          else
            form_pdf.render_text text_block[1]
          end
        end
      elsif question.context.present? || question.pdf_context.present?
        render_context_or_help_block(question.escaped_context)
      end
    end
  end

  def render_question_help_note
    if question.help.any? && urn_blank_or_pdf_blank_mode?
      question.help.each do |help|
        h_text = question.escaped_help(help.text)
        render_context_or_help_block(h_text) if h_text.present?
      end
    end
  end

  def render_question_hints
    if question.hint.any? && urn_blank_or_pdf_blank_mode?
      question.hint.each_with_index do |help, index|
        if help.title.present?
          form_pdf.render_text question.prepared_text(help.title), style: :bold
        end

        r_text = help.text.squeeze(" ").delete("\n")
        form_pdf.render_text question.prepared_text(r_text)
      end
    end
  end

  def render_context_or_help_block(context)
    if question.classes == "application-notice help-notice"
      form_pdf.image "#{Rails.root}/app/assets/images/icon-important-print.png",
                     at: [-10.mm, form_pdf.cursor - 3.5.mm],
                     width: 6.5.mm,
                     height: 6.5.mm
      form_pdf.render_text context,
                           style: :bold
    else
      form_pdf.render_text context
    end
  end

  def render_validation_block
    # Valid/pending icon
    # TODO If it has validation
    if false
      # TODO If it is valid
      if false
        valid_icon = "icon-valid-pdf.png"
      else
        valid_icon = "icon-pending-pdf.png"
      end

      form_pdf.image "#{Rails.root}/app/assets/images/#{valid_icon}",
                     at: [0, form_pdf.cursor - 4.mm],
                     width: 7.mm
    end
  end

  def render_question_sub_title
    if question.question_sub_title.present?
      form_pdf.move_up 5.mm
      form_pdf.render_text question.question_sub_title
      form_pdf.move_up 5.mm
    end
  end

  def render_info_about_conditional_parent
    if answer.blank? && urn_blank_or_pdf_blank_mode?

      hints = question.pdf_conditional_hints(non_header_questions)

      if hints.present?
        form_pdf.render_text hints, style: :italic
      end
    end
  end

  def question_block_type(question)
    unless FormPdf::JUST_NOTES.include?(question.delegate_obj.class.to_s)
      if BLOCK_QUESTIONS.include?(question.delegate_obj.class) && RENDER_INLINE_KEYS.exclude?(question.key.to_s)
        "block"
      else
        "inline"
      end
    end
  end

  def question_answer(question)
    unless FormPdf::JUST_NOTES.include?(question.delegate_obj.class.to_s)
      case question.delegate_obj
      when QaeFormBuilder::UploadQuestion
        form_pdf.indent 7.mm do
          render_attachments
        end
      when QaeFormBuilder::SicCodeDropdownQuestion
        if q_visible? && humanized_answer.present?
          form_pdf.render_standart_answer_block(question_option_title)
        else
          form_pdf.default_bottom_margin
          form_pdf.text "Select #{question.title}"
        end
      when QaeFormBuilder::OptionsQuestion
        if q_visible? && humanized_answer.present?
          chosen_option = question.options.detect{ |option| option.value.to_s == humanized_answer.to_s }
          form_pdf.render_standart_answer_block(question_option_title)
          render_context_for_option(question, chosen_option)
        else
          form_pdf.indent 7.mm do
            question.options.each do |answer|
              unless answer.value.blank?
                question_option_box answer.text
                render_context_for_option(question, answer)
              end
            end
          end
        end
      when QaeFormBuilder::ConfirmQuestion
        if q_visible? && humanized_answer.present?
          form_pdf.render_standart_answer_block(question_checked_value_title)
        else
          question_option_box(question.pdf_text || question.text)
        end
      when QaeFormBuilder::ByYearsLabelQuestion, QaeFormBuilder::OneOptionByYearsLabelQuestion
        form_pdf.indent 7.mm do
          render_years_labels_table
        end
      when QaeFormBuilder::ByYearsQuestion, QaeFormBuilder::OneOptionByYearsQuestion
        render_years_table
      when QaeFormBuilder::SupportersQuestion
        render_supporters
      when QaeFormBuilder::TextareaQuestion
        title = q_visible? && humanized_answer.present? ? humanized_answer : ""

        form_pdf.default_bottom_margin
        render_word_limit
        render_wysywyg_content
      when QaeFormBuilder::CheckboxSeriaQuestion
        render_checkbox_selected_values
      else
        title = q_visible? && humanized_answer.present? ? humanized_answer : ""
        form_pdf.render_standart_answer_block(title)
      end
    end
  end

  def render_word_limit
    if question.delegate_obj.respond_to?(:words_max) &&
       question.words_max.present? &&
       urn_blank_or_pdf_blank_mode?
      form_pdf.text "Word limit: #{question.words_max}"
      form_pdf.move_down 2.5.mm
    end
  end

  def render_attachments
    if humanized_answer.present?
      humanized_answer.each do |k, v|
        attachment_by_type(k, v)
      end
    end
  end

  def attachment_by_type(_k, v)
    if v.keys.include?("file")
      attachment = form_pdf.form_answer_attachments.detect do |a|
        a.id.to_s == v["file"]
      end

      if attachment.present?
        form_pdf.draw_link_with_file_attachment(attachment, v["description"])
      end
    elsif v.keys.include?("link")
      if v["link"].present?
        form_pdf.draw_link(v)
      end
    else
      fail UNDEFINED_TYPE
    end
  end

  def complex_question
    render_question_title_with_ref_or_not
    if question.delegate_obj.class.to_s == "QaeFormBuilder::HeadOfBusinessQuestion"
      form_pdf.move_up 5.mm
    end

    if question.delegate_obj.class.to_s == "QaeFormBuilder::AddressQuestion"
      render_context_and_answer_blocks
    end

    form_pdf.indent 25.mm do
      if sub_answers.length > 1
        sub_answers_by_type
      else
        first_sub_question = sub_answers[0][1]
        sub_question_block_without_title(first_sub_question)
      end
    end
  end

  def sub_answers_by_type
    case key.to_s
    when *FormPdf::TABLE_WITH_COMMENT_QUESTION
      render_table_with_optional_extra
    when *FormPdf::INLINE_DATE_QUESTION
      render_inline_date
    else
      render_sub_questions(sub_answers)
    end
  end

  def render_table_with_optional_extra
    cells = sub_answers.select do |a|
      a[0].match(/\/{1}[0-9]{2}\/{1}/).present? ||
      a[0].match(/Year/).present?
    end

    if cells.present?
      headers = cells.map { |a| a[0] }
      row = cells.map { |a| q_visible? ? a[1] : "" }
      render_single_row_table(headers, row)
    end

    comments = sub_answers - cells
    render_sub_questions(comments) if comments.present?
  end

  def render_single_row_table(headers, row)
    table_lines = [headers, row]
    form_pdf.render_table(table_lines)
  end

  def render_multirows_table(headers, rows)
    table_lines = rows.unshift(headers).compact
    form_pdf.render_table(table_lines)
  end

  def render_single_row_list(headers, row)
    form_pdf.indent 7.mm do
      headers.each_with_index do |_col, index|
        form_pdf.default_bottom_margin

        res = q_visible? ? "#{ANSWER_FONT_START}#{row[index]}#{ANSWER_FONT_END}" : ""
        form_pdf.text "#{headers[index]}: #{res}",
                      inline_format: true
      end
    end
  end

  def render_inline_date
    headers = sub_answers.map { |a| a[0] }
    row = sub_answers.map { |a| a[1] }
    row[1] = to_month(row[1]) if row[1].present?
    empty_date = false

    title = if q_visible? && row[0] != ""
      row.join(" ")
    else
      empty_date = true

      if row.size > 2
        "Day Month Year"
      else
        "Day Month"
      end
    end

    render_question_context
    render_question_help_note
    render_question_hints

    if !empty_date
      form_pdf.render_standart_answer_block(title)
    else
      form_pdf.render_text title
    end
  end

  def render_sub_questions(items)
    items.each do |sub_question, sub_answer|
      sub_question_block(sub_question, sub_answer)
    end
  end

  def sub_question_block(sub_question, sub_answer)
    form_pdf.default_bottom_margin
    res = q_visible? ? "#{ANSWER_FONT_START}#{sub_answer}#{ANSWER_FONT_END}" : ""
    form_pdf.text "#{sub_question}: #{res}",
                  inline_format: true
  end

  def sub_question_block_without_title(sub_answer)
    if question.can_have_parent_conditional_hints? && question.have_conditional_parent?
      form_pdf.indent -25.mm do # compensating 25mm indent for subquestion
        render_info_about_conditional_parent
      end
    end
    form_pdf.render_text (q_visible? ? sub_answer : ""),
                         color: FormPdf::DEFAULT_ANSWER_COLOR
  end

  def question_option_title
    res = question.options.detect do |option|
      option.value.to_s == humanized_answer.to_s
    end

    q_visible? && res.present? ? res.text : ""
  end

  def question_option_box(title)
    form_pdf.default_bottom_margin

    # This adds some text so that we can be sure that the box and question text stay together between pages
    form_pdf.text "Test", color: "ffffff"
    form_pdf.move_up 4.5.mm

    form_pdf.bounding_box([0, form_pdf.cursor], width: 3.mm, height: 3.mm) do
      form_pdf.stroke_color "333333"
      form_pdf.stroke_bounds
    end

    form_pdf.move_up 3.mm

    form_pdf.indent 6.mm do
      form_pdf.text prepared_checkbox_value(title), inline_format: true
    end
  end

  def question_checked_value_title
    question_text = question.pdf_text || question.text
    Nokogiri::HTML.parse(question_text).text.strip if humanized_answer == "on"
  end

  def prepared_checkbox_value(title)
    Sanitize.fragment(title, elements: ["strong"], :parser_options => {
      max_errors: -1,
      max_tree_depth: -1
    }
    ).strip
  end

  def to_month(value)
    Date::MONTHNAMES[value.to_i]
  end

  def financial_data(question_key, question_data)
    question_data.map do |entry|
      if entry.is_a?(Array)
        entry.join("/")
      else
        data_by_type(question_key, entry)
      end
    end
  end

  def data_by_type(question_key, entry)
    if entry[:value].present?
      if NOT_CURRENCY_QUESTION_KEYS.include?(question_key)
        entry[:value]
      else
        "£#{entry[:value]}" if entry[:value] != "-"
      end
    end
  end

  def render_context_for_option(question, answer)
    context = question.context_for_option(answer&.value)
    if context
      form_pdf.move_down 3.mm
      form_pdf.indent 7.mm do
        if context.is_a?(Array)
          context.map do |text_block|
            if text_block[0] == :bold
              form_pdf.render_text text_block[1], style: :bold
            elsif text_block[0] == :italic
              form_pdf.render_text text_block[1], style: :italic
            else
              form_pdf.render_text text_block[1]
            end
          end
        else
          form_pdf.text context
        end
      end
    end
  end
end
