class Lieutenant::FormAnswersController < Lieutenant::BaseController
  include FormAnswerMixin
  include FormAnswerSubmissionMixin

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

  def index
    authorize :form_answer, :index?
    params[:search] ||= {
      sort: "company_or_nominee_name",
      search_filter: {
        status: FormAnswerStatus::LieutenantFilter::checked_options.invert.values
      }
    }
    params[:search].permit!
    scope = current_lieutenant.nominations_scope(
      params[:year].to_s == "all_years" ? nil : @award_year
    )

    @search = FormAnswerSearch.new(scope, current_assessor).search(params[:search])
    @search.ordered_by = "company_or_nominee_name" unless @search.ordered_by

    @form_answers = @search.results
                      .with_comments_counters
                      .group("form_answers.id")
                      .page(params[:page])
  end

  def edit
    authorize resource, :edit?
    @form = resource.award_form.decorate(answers: HashWithIndifferentAccess.new(resource.document))
  end

  def save
    authorize resource, :edit?

    @form_answer.document = prepare_doc if params[:form].present?
    @form = @form_answer.award_form.decorate(answers: HashWithIndifferentAccess.new(@form_answer.document))

    redirected = params[:next_action] == "redirect"
    submitted = params[:submit] == "true" && !redirected

    respond_to do |format|
      format.html do
        redirected = params[:next_action] == "redirect"

        if submitted
          @form_answer.submitted_at = Time.current
        end

        submitted_was_changed = @form_answer.submitted_at_changed? && @form_answer.submitted_at_was.nil?
        @form_answer.current_step = params[:current_step] || @form.steps.first.title.parameterize
        if params[:form].present? && @form_answer.eligible? && (saved = @form_answer.save)
          if submitted_was_changed
            @form_answer.state_machine.l_submit(current_lieutenant)
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
          redirect_to lieutenant_form_answer_url(@form_answer)
          return
        else
          if submitted && saved
            redirect_to lieutenant_form_answer_submit_confirm_url(@form_answer)
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
    when "edit", "update"
      "application"
    else
      "application-lieutenant"
    end
  end
end
