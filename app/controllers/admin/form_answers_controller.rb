class Admin::FormAnswersController < Admin::BaseController
  include FormAnswerMixin

  before_action :load_resource, only: [
    :review,
    :show,
    :eligibility,
    :update,
    :update_financials,
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
    else
      @award_year.form_answers
    end
  end

  def index
    params[:search] ||= FormAnswerSearch.default_search
    params[:search].permit!
    authorize :form_answer, :index?

    @search = FormAnswerSearch.new(target_scope, current_admin).search(params[:search])
    @search.ordered_by = "company_or_nominee_name" unless @search.ordered_by
    @form_answers = @search.results
                      .with_comments_counters
                      .group("form_answers.id")
                      .page(params[:page])
  end

  def show
    super
    @audit_events = FormAnswerAuditor.new(@form_answer).get_audit_events
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

  def edit
    authorize resource
    sign_in(@form_answer.user, scope: :user, skip_session_limitable: true)
    session[:admin_in_read_only_mode] = false
    redirect_to edit_form_path(resource)
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

  private

  helper_method :resource,
                :primary_assessment,
                :secondary_assessment,
                :moderated_assessment,
                :case_summary_assessment

  def resource
    @form_answer ||= load_resource
  end

  def load_versions
    @versions = FormAnswerVersionsDispatcher.new(@form_answer).versions
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
end
