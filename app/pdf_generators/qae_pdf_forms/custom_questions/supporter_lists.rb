module QaePdfForms::CustomQuestions::SupporterLists
  include FormAnswerHelper
  def render_supporters
    entries = form_answer.support_letters.manual

    if entries.present? && form_pdf.pdf_blank_mode.blank?
      render_supporters_list(entries)
    end
  end

  def render_supporters_list(entries)
    entries.each_with_index do |entry, index|
      ops = [
        { ref: "C #{index + 1}.1", title: "name_of_the_person_who_wrote_the_#{ordinal_label(index)}_letter_of_support".to_sym, value: ''},
        { sub_field: "first_name".to_sym, value: entry.first_name },
        { sub_field: "last_name".to_sym, value: entry.last_name },
        { ref: "C #{index + 1}.2", title: "relationship_to_nominee".to_sym, value: entry.relationship_to_nominee, hint: "For example, a beneficiary of the group, local resident or member of a partner charity." },
      ]

      render_supporter(entry, ops, index)
    end
  end

  def render_supporter(entry, ops, index)
    form_pdf.text "C #{index + 1}. The #{ordinal_label(index)} letter of support", style: :bold
    form_pdf.move_down 2.5.mm

    ops.each do |op|
      if op[:ref]
        form_pdf.text op[:ref], style: :bold
        form_pdf.move_cursor_to form_pdf.cursor + 10.mm
        form_pdf.indent(13.mm) { form_pdf.render_text format_label(op[:title]), style: :bold } if op[:title]
        form_pdf.move_down 5.mm
        form_pdf.text(op[:hint], style: :italic) if op[:hint]
      else
        form_pdf.indent 16.mm do
          form_pdf.render_text format_label(op[:sub_field])
          form_pdf.render_text op[:value]
        end
      end
      form_pdf.move_down 5.mm
    end

    if entry.is_a?(SupportLetter)
      render_support_letter(entry, index)
    end
  end

  def format_label(text)
    text.to_s.split('_').join(' ').capitalize
  end

  def render_support_letter(entry, index)
    form_pdf.text "C #{index + 1}.3. Upload the #{ordinal_label(index)} letter of support: ", style: :bold

    if entry.support_letter_attachment.present?
      form_pdf.base_link_sceleton(
        form_pdf.attachment_path(entry.support_letter_attachment.attachment, true),
        entry.support_letter_attachment.original_filename.truncate(60)
      )
    end

    form_pdf.move_down 2.5.mm
  end
end
