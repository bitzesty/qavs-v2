class Admin::DashboardController < Admin::BaseController
  before_action :redirect_to_nominations

  def index
    authorize :dashboard, :index?
    @statistics = FormAnswerStatistics::Picker.new(@award_year)
  end

  def downloads
    authorize :dashboard, :index?
  end

  def totals_by_month
    authorize :dashboard, :totals_by_month?
  end

  def totals_by_week
    authorize :dashboard, :totals_by_week?
  end

  def totals_by_day
    authorize :dashboard, :totals_by_day?
  end

  private

  def redirect_to_nominations
    redirect_to admin_form_answers_url
  end
end
