module AdminHelper
  def admin_conditional_pdf_link_target(form_answer, mode)
    if form_answer.hard_copy_ready_for?(mode) && !Rails.env.development?
      "_blank"
    else
      ""
    end
  end

  def admin_conditional_aggregated_pdf_link_target(award_year, mode)
    if award_year.aggregated_hard_copies_completed?(mode) && !Rails.env.development?
      "_blank"
    else
      ""
    end
  end

  def comment_author(entry)
    author = entry.author

    if author.present?
      base = author.email
      base += " (deleted account)" if author.deleted?

      base
    else
      "Written by author who is no longer active"
    end
  end

  def message_author_name(author)
    author.present? ? author.decorate.full_name : 'author who is no longer active'
  end

  def time_collection_options
    options = []

    for i in 0..24 do
      options << ["#{i.to_s.rjust(2, '0')}:00", 60 * 60 * i]
      options << ["#{i.to_s.rjust(2, '0')}:30", ((60 * 60 * i) + 60 * 60 * 0.5).to_i]
    end

    options
  end
end
