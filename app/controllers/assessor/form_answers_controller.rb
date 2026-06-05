class Assessor::FormAnswersController < Assessor::BaseController
  include FormAnswerMixin
  include FormAnswersPdf

  layout :resolve_layout

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

  helper_method :resource,
                :category_picker

  def index
    authorize :form_answer, :index?
    search_params = save_or_load_search!
    return if search_params.nil? # Redirected from save_or_load_search!

    scope = current_assessor.applications_scope(
      params[:year].to_s == "all_years" ? nil : @award_year
    ).includes(:assessor_assignments).eligible_for_assessor

    if search_params[:query].blank? && category_picker.show_award_tabs_for_assessor?
      scope = scope.where(award_type: category_picker.current_award_type)
    end

    @search = FormAnswerSearch.new(scope, current_assessor).search(search_params)
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
        when "assessor_decisions_data"
          csv = Reports::AssessorDecisionsReport.new(@search.results.includes(assessor_assignments: :assessor), @award_year, current_assessor).build
          filename = "assessor_decisions_report_#{timestamp}.csv"
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
    authorize resource, :show?
    @admin_verdict = resource.admin_verdict

    respond_to do |format|
      format.html

      format.pdf do
        if can_render_pdf_on_fly?
          pdf = resource.decorate.pdf_generator(current_assessor, pdf_blank_mode)
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

  def edit
    authorize resource, :edit?

    unless assessor_assignment.status
      assessor_assignment.update(status: "viewed")
    end

    @form = resource.award_form.decorate(answers: HashWithIndifferentAccess.new(resource.document))
  end

  private

  def resource
    @form_answer ||= current_assessor.applications_scope(@award_year).includes(:assessor_assignments).find(params[:id]).decorate
  end

  def category_picker
    CurrentAwardTypePicker.new(current_subject, params)
  end

  def default_filters
    FormAnswerSearch.default_search
  end

  def resolve_layout
    case action_name
    when "edit"
      "application"
    else
      "application-assessor"
    end
  end

  def assessor_assignment
    AssessorAssignment.find_by(assessor_id: current_assessor.id, form_answer_id: resource.id) ||
    resource.assessor_assignments.build(assessor: current_assessor, award_year: @award_year)
  end
end
