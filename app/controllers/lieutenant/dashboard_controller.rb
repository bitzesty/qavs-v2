class Lieutenant::DashboardController < Lieutenant::BaseController
  def show
    authorize :lieutenant_dashboard, :show?
  end
end
