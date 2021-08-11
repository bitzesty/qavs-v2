class Admin::DashboardController < Admin::BaseController
  def index
    authorize :dashboard, :index?
    @statistics = FormAnswerStatistics::Picker.new(@award_year)
    redirect_to_nominations
  end

  def downloads
    authorize :dashboard, :index?
    redirect_to_nominations
  end

  def totals_by_month
    authorize :dashboard, :totals_by_month?
    redirect_to_nominations
  end

  def totals_by_week
    authorize :dashboard, :totals_by_week?
    redirect_to_nominations
  end

  def totals_by_day
    authorize :dashboard, :totals_by_day?
    redirect_to_nominations
  end

  private

  def redirect_to_nominations
    redirect_to admin_form_answers_url
  end
end
