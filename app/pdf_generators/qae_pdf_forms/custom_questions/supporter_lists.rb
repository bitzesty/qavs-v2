module QaePdfForms::CustomQuestions::SupporterLists
  def render_supporters
    entries = form_answer.support_letters.manual

    if entries.present? && form_pdf.pdf_blank_mode.blank?
      render_supporters_list(entries)
    end
  end

  def render_supporters_list(entries)
    entries.each do |entry|
      ops = {
        full_name: "#{entry.first_name} #{entry.last_name}",
        relationship_to_nominee: entry.relationship_to_nominee
      }

      render_supporter(entry, ops)
    end
  end

  def render_supporter(entry, ops)
    form_pdf.move_down 5.mm

    ops.each do |option_title, option_value|
      form_pdf.text "#{option_title.to_s.split("_").join(" ").capitalize}: ", style: :bold
      form_pdf.text option_value
      form_pdf.move_down 2.5.mm
    end

    if entry.is_a?(SupportLetter)
      render_support_letter(entry)
    end
  end

  def render_support_letter(entry)
    form_pdf.text "Letter of Support: ", style: :bold

    if entry.support_letter_attachment.present?
      form_pdf.base_link_sceleton(
        form_pdf.attachment_path(entry.support_letter_attachment.attachment, true),
        entry.support_letter_attachment.original_filename.truncate(60)
      )
    end

    form_pdf.move_down 2.5.mm
  end
end
