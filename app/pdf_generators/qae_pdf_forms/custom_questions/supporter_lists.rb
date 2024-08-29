module QaePdfForms::CustomQuestions::SupporterLists
  def render_supporters
    entries = form_answer.support_letters.manual

    if entries.present? && form_pdf.pdf_blank_mode.blank?
      render_supporters_list(entries)
    end
  end

  def render_supporters_list(entries)
    entries.each_with_index do |entry, index|
      entry_index = index == 0 ? "first" : "second"
      ops = [
        { title: "name_of_the_person_who_wrote_the_#{entry_index}_letter_of_support".to_sym, value: ''},
        { sub_field: "first_name".to_sym, value: entry.first_name },
        { sub_field: "last_name".to_sym, value: entry.last_name },
        { title: "relationship_to_nominee".to_sym, value: entry.relationship_to_nominee, hint: "For example, a beneficiary of the group, local resident or member of a partner charity." },
      ]

      render_supporter(entry, ops, entry_index)
    end
  end

  def render_supporter(entry, ops, entry_index)
    form_pdf.move_down 5.mm

    ops.each do |op|
      form_pdf.text "#{format_label(op[:title])}: ", style: :bold if op[:title]
      form_pdf.text "#{format_label(op[:sub_field])}: " if op[:sub_field]
      form_pdf.text(op[:hint], style: :italic) if op[:hint]
      form_pdf.text op[:value]
      form_pdf.move_down 2.5.mm
    end

    if entry.is_a?(SupportLetter)
      render_support_letter(entry, entry_index)
    end
  end

  def format_label(text)
    text.to_s.split('_').join(' ').capitalize
  end

  def render_support_letter(entry, entry_index)
    form_pdf.text "Upload the #{entry_index} letter of support: ", style: :bold

    if entry.support_letter_attachment.present?
      form_pdf.base_link_sceleton(
        form_pdf.attachment_path(entry.support_letter_attachment.attachment, true),
        entry.support_letter_attachment.original_filename.truncate(60)
      )
    end

    form_pdf.move_down 2.5.mm
  end
end
