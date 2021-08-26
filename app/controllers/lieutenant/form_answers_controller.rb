class Lieutenant::FormAnswersController < Lieutenant::BaseController
  include FormAnswerMixin
  include FormAnswerSubmissionMixin
  include FormAnswersPdf

  helper_method :resource

  before_action :find_resource, only: [:show, :edit, :update, :save]

  layout :resolve_layout

  expose(:all_form_questions) do
    @form_answer.award_form.steps.map(&:questions).flatten
  end

  expose(:questions_with_references) do
    all_form_questions.select do |q|
      !q.is_a?(QAEFormBuilder::HeaderQuestion) &&
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

  def show
    authorize resource, :show?

    respond_to do |format|
      format.html

      format.pdf do
        if can_render_pdf_on_fly?
          pdf = resource.decorate.pdf_generator(current_lieutenant, pdf_blank_mode)
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

  def index
    authorize :form_answer, :index?
    params[:search] ||= {
      sort: "company_or_nominee_name",
      search_filter: {
        nominee_activity: FormAnswerStatus::LieutenantFilter::checked_options.invert.values
      }
    }
    params[:search].permit!
    scope = current_lieutenant.nominations_scope(
      params[:year].to_s == "all_years" ? nil : @award_year
    ).eligible_for_lieutenant

    @search = FormAnswerSearch.new(scope, current_lieutenant).search(params[:search])
    @search.ordered_by = "company_or_nominee_name" unless @search.ordered_by

    @form_answers = @search.results
                      .with_comments_counters
                      .group("form_answers.id")
                      .page(params[:page])
  end

  def edit
    authorize resource, :edit?

    resource.state_machine.perform_transition(:local_assessment_in_progress, current_lieutenant)

    @form = resource.award_form.decorate(answers: HashWithIndifferentAccess.new(resource.document))
  end

  def save
    authorize resource, :edit?

    @form_answer.document = prepare_doc if params[:form].present?
    @form = @form_answer.award_form.decorate(answers: HashWithIndifferentAccess.new(@form_answer.document))

    redirected = params[:next_action] == "redirect"
    submitted = params[:submit] == "true" && !redirected

    authorize resource, :submit? if submitted

    respond_to do |format|
      format.html do
        redirected = params[:next_action] == "redirect"

        params[:form].present? && @form_answer.eligible? && (saved = @form_answer.save)
        # HardCopyPdfGenerators::FormDataWorker.perform_async(@form_answer.id, true)

        if redirected
          redirect_to lieutenant_form_answer_url(@form_answer)
          return
        else
          if submitted && saved
            LocalAssessmentSubmissionService.new(@form_answer, current_lieutenant).submit!

            flash[:success] = "Local assessment was successfully submitted."
            redirect_to lieutenant_form_answer_url(@form_answer)
          else
            if saved
              params[:next_step] ||= @form.steps[1].title.parameterize
              redirect_to edit_lieutenant_form_answer_path(@form_answer, step: params[:next_step])
            else
              params[:step] = @form_answer.steps_with_errors.try(:first)
              # avoid redirecting to supporters page
              if !params[:step] || params[:step] == "letters-of-support"
                params[:step] = @form.steps.first.title.parameterize
              end

              render template: "lieutenants/form_answers/edit"
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
          flash[:success] = "Local assessment was successfully saved."
          if submitted_was_changed
            @form_answer.state_machine.submit(current_user)
            FormAnswerUserSubmissionService.new(@form_answer).perform
          end
        end

        render json: { progress: @form_answer.fill_progress }
      end
    end
  end

  private

  def find_resource
    @form_answer ||= current_lieutenant.assigned_nominations.find(params[:id]).decorate
  end

  def resource
    @form_answer
  end

  def resolve_layout
    case action_name
    when "edit", "update", "save"
      "application"
    else
      "application-lieutenant"
    end
  end
end
