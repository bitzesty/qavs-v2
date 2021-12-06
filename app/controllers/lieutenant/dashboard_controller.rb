class Lieutenant::DashboardController < Lieutenant::BaseController
  def index
    authorize :lieutenant_dashboard, :index?
  end
end
