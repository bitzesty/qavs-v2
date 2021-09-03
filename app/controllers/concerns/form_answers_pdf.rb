module FormAnswersPdf
  def can_render_pdf_on_fly?
    #
    # Render PDF on fly only if:
    #
    # 1) 'Download blank PDF'
    #
    # 2) Submission IS NOT ended for current application award year
    #
    # 3) Submission IS ended for current application award year,
    #    but application is not submitted and
    #    application's award year equal current award year (because
    #    PDF formatting changes from year to year and we can' generate
    #    PDF on fly for previous award years)
    #

    pdf_blank_mode ||
    !resource.local_assessment_ended? ||
    (
      resource.local_assessment_ended? &&
      !resource.submitted? &&
      resource.award_year_id == AwardYear.current.id
    )
  end

  def render_hard_copy_pdf
    if resource.pdf_version.present?
      redirect_to resource.pdf_version.url
    else
      if !admin_in_read_only_mode?
        redirect_to dashboard_path,
                    notice: "PDF version for your application is not available!"
      else
        flash[:notice] = "PDF version for your application is not available!"
        redirect_back(fallback_location: root_path)
      end
    end
  end

  def pdf_blank_mode
    params[:pdf_blank_mode].present?
  end
end
