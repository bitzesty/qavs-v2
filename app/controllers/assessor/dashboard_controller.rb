class Assessor::DashboardController < Assessor::BaseController
  def index
    authorize :assessor_dashboard, :index?
  end
end
