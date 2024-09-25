class Admin::FormAnswersController < Admin::BaseController
  include FormAnswerMixin
  include FormAnswerSubmissionMixin
  include FormAnswersPdf

  layout :resolve_layout

  before_action :load_resource, only: [
    :review,
    :show,
    :eligibility,
    :update,
    :update_verdict,
    :save,
    :remove_audit_certificate
  ]

  skip_after_action :verify_authorized, only: [:awarded_trade_applications]

  expose(:financial_pointer) do
    FormFinancialPointer.new(@form_answer, {
      exclude_ignored_questions: true,
      financial_summary_view: true
    })
  end

  expose(:target_scope) do
    if params[:year].to_s == "all_years"
      FormAnswer.all
    elsif params[:year].present?
      (year = AwardYear.find_by(year: params[:year])) ? year.form_answers : FormAnswer.none
    else
      @award_year.form_answers
    end
  end

  expose(:all_form_questions) do
    @form_answer.award_form.steps.map(&:questions).flatten
  end

  expose(:questions_with_references) do
    all_form_questions.select do |q|
      !q.is_a?(QaeFormBuilder::HeaderQuestion) &&
      (q.ref.present? || q.sub_ref.present?)
    end
  end

  expose(:support_letter_attachments) do
    resource.support_letter_attachments.inject({}) do |r, attachment|
      r[attachment.id] = attachment
      r
    end
  end

  expose(:original_form_answer) do
    resource.original_form_answer
  end

  def index
    authorize :form_answer, :index?
    search_params = save_or_load_search!
    return if search_params.nil? # Redirected from save_or_load_search!

    @search = FormAnswerSearch.new(target_scope, current_admin).search(search_params)
    @search.ordered_by = "company_or_nominee_name" unless @search.ordered_by
    @form_answers = @search.results
                      .with_comments_counters
                      .group("form_answers.id")
                      .page(params[:page])
    respond_to do |format|
      format.html

      format.csv do
        timestamp = Time.zone.now.strftime("%d-%m-%Y")

        case params[:report_kind]
        when "nomination_data"
          csv = Reports::NominationsReport.new(@search.results).build
          filename = "nominations_report_#{timestamp}.csv"
        when "local_assessment_data"
          csv = Reports::LocalAssessmentReport.new(@search.results).build
          filename = "local_assessments_report_#{timestamp}.csv"
        when "national_assessment_data"
          csv = Reports::NationalAssessmentsReport.new(@search.results.includes(assessor_assignments: :assessor), @award_year).build
          filename = "national_assessments_report_#{timestamp}.csv"
        end

        send_data(
          csv.force_encoding(::Encoding::UTF_8),
          filename: filename,
          type: 'text/csv; charset=Unicode(UTF-8); header=present',
          disposition: 'attachment'
        )
      end
    end
  end

  def show
    super

    respond_to do |format|
      format.html do
        @audit_events = FormAnswerAuditor.new(resource).get_audit_events
      end

      format.pdf do
        if can_render_pdf_on_fly?
          pdf = resource.decorate.pdf_generator(current_admin, pdf_blank_mode)
          send_data pdf.render,
                    filename: resource.decorate.pdf_filename,
                    type: "application/pdf",
                    disposition: 'attachment'
        else
          render_hard_copy_pdf
        end
      end
    end
  end

  def save
    authorize @form_answer, :submit?
    @form_answer.document = prepare_doc if params[:form].present?
    @form = @form_answer.award_form.decorate(answers: HashWithIndifferentAccess.new(@form_answer.document))

    redirected = params[:next_action] == "redirect"
    submitted = params[:submit] == "true" && !redirected

    respond_to do |format|
      format.html do
        if submitted
          @form_answer.submitted_at = Time.current
        end

        submitted_was_changed = @form_answer.submitted_at_changed? && @form_answer.submitted_at_was.nil?
        @form_answer.current_step = params[:current_step] || @form.steps.first.title_to_param
        if params[:form].present? && @form_answer.eligible? && (saved = @form_answer.save)
          if submitted_was_changed
            @form_answer.state_machine.submit(current_admin)
            FormAnswerUserSubmissionService.new(@form_answer).perform

            if @form_answer.submission_ended?
              #
              # If submission period ended and Admin makes manual submission
              # then we need to generate Hard Copy PDF file
              # as it required for all submitted applications after submission deadline.
              #
              HardCopyPdfGenerators::FormDataWorker.perform_async(@form_answer.id, true)
            end
          end
        end

        if redirected
          redirect_to admin_form_answer_url(@form_answer)
        else
          if submitted && saved
            redirect_to admin_form_answer_url(@form_answer)
          else
            if saved
              params[:next_step] ||= @form.steps[1].title_to_param
              redirect_to edit_admin_form_answer_url(@form_answer, step: params[:next_step])
            else
              params[:step] = @form_answer.steps_with_errors.try(:first)
              # avoid redirecting to supporters page
              if !params[:step] || params[:step] == "letters-of-support"
                params[:step] = @form.steps.first.title_to_param
              end

              render template: "admin/form_answers/edit"
            end
          end
        end
      end

      format.js do
        if submitted
          @form_answer.submitted_at = Time.current
        end

        submitted_was_changed = @form_answer.submitted_at_changed? && @form_answer.submitted_at_was.nil?

        if params[:form].present? && @form_answer.eligible? && @form_answer.save
          if submitted_was_changed
            @form_answer.state_machine.submit(current_admin)
            FormAnswerUserSubmissionService.new(@form_answer).perform
          end
        end

        render json: { progress: @form_answer.fill_progress }
      end
    end
  end

  def eligibility
    authorize resource
  end

  def update_eligibility
    authorize resource

    resource.assign_attributes(eligibility_params)

    if resource.save
      redirect_to admin_form_answer_path(resource), notice: "Eligibility status was successfully updated."
    else
      render :eligibility
    end
  end

  def update_verdict
    @admin_verdict = resource.admin_verdict || resource.build_admin_verdict

    authorize @admin_verdict, :update?

    @admin_verdict.attributes = verdict_params

    if @admin_verdict.save
      redirect_to [:admin, resource], success: "National assessment and Royal approval outcome successfully saved."
    else
      render :show
    end
  end

  def edit
    authorize resource
    @form = resource.award_form.decorate(answers: HashWithIndifferentAccess.new(resource.document))
    session[:admin_in_read_only_mode] = false
  end

  def remove_audit_certificate
    authorize @form_answer, :remove_audit_certificate?

    @form_answer.audit_certificate.destroy

    respond_to do |format|
      format.html do
        flash.notice = "Verification of Commercial Figures successfully removed"
        redirect_to admin_form_answer_url(@form_answer)
      end
      format.js do
        head :ok
      end
    end
  end

  def awarded_trade_applications
    @csv_data = AwardedTradeApplicationsCsv.run

    send_data(
      @csv_data.force_encoding(::Encoding::UTF_8),
      filename: "awarded_trade_applications.csv",
      type: 'text/csv; charset=Unicode(UTF-8); header=present',
      disposition: 'attachment'
    )
  end

  # batch actions

  def bulk_assign_lieutenants
    authorize :lieutenant_assignment_collection, :create?
    form_answer_ids = if params[:bulk_action]
      params[:bulk_action][:ids]
    elsif params[:lieutenant_assignment_collection]
      # get form_answer_ids after validation error
      params[:lieutenant_assignment_collection][:form_answer_ids]
    end

    @form = LieutenantAssignmentCollection.new(form_answer_ids: form_answer_ids, params: bulk_assign_params)
  end

  def bulk_assign_assessors
    authorize :assessor_assignment_collection, :create?

    form_answer_ids = params[:bulk_action][:ids]
    @form = AssessorAssignmentCollection.new(form_answer_ids: form_answer_ids)
  end

  def bulk_assign_eligibility
    authorize :eligibility_assignment_collection, :create?

    form_answer_ids = if params[:bulk_action]
      params[:bulk_action][:ids]
    elsif params[:lieutenant_assignment_collection]
      # get form_answer_ids after validation error
      params[:lieutenant_assignment_collection][:form_answer_ids]
    end

    @form = EligibilityAssignmentCollection.new(form_answer_ids: form_answer_ids)
  end

  # / batch actions

  private

  helper_method :resource

  def resource
    @form_answer ||= load_resource
  end

  def load_versions
    @versions = FormAnswerVersionsDispatcher.new(@form_answer).versions
  end

  def default_filters
    FormAnswerSearch.default_search
  end

  def eligibility_params
    params
      .require(:form_answer)
      .permit(
        :state,
        :ineligible_reason_nominator,
        :ineligible_reason_group
      )
  end

  def bulk_assign_params
    # params.require(:bulk_action).permit(ids: []).merge(params.permit(:bulk_assign_lieutenants))
    params.permit!
  end

  def resolve_layout
    case action_name
    when "edit", "update", "save"
      "application"
    else
      "application-admin"
    end
  end

  def verdict_params
    params.require(:admin_verdict).permit(
      :outcome,
      :description
    )
  end
end
